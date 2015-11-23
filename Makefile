# TODO this could use a refactor
# thinking a staging area/preprocessor would solve a lot of problems
#
# init recipe that creates build/, staging/, symlinks
# staging recipes do simple text transforms like xVAR replacement
# index.html, eg, assembled entirely in staging, simple search-replace
# in other words it depends only on templates and itself, uncomplicated
# something like makefile.html though, multiple dynamic assets combine
# rather than a special case, run makefile.html thru same as index.html
# leave behind xMAKEFILE, eg. then Makefile gets its own recipe
# html escaping and fancier stuff like line numbers/syntax highlight
# both files go to staging, build step simply combines them
#
# another big one, the fucking loop eval
# trying to piece it together in-place was a mistake
# instead of depending on all files in one recipe, go with %.html again
# recipe writes one block per file to staging, build simply cats them
# this also saves me from nightmares doing meat-readable sitemap
# current design I'd have to write another one of those loop-strings
# new design, sitemap block recipe just gets a second job to do
#
# will make adding a blog platform to the system much more painless too
# staging step transforms markdown posts into html, spellcheck, etc
# write out excerpts, xVAR, removed from full post, sliced for previews
# builds dynamic elements like whatever blog links to blog things
# eg "recent posts" list, category page, tag page, calendar page
# build step inserts post into template like makefile.html does
# inserts excerpt blocks into main/history-style "next 10" pages

# FIXME dev/prod base href?
# w3m pukes on base href="/", so I'm hardcoding the full path
# but this makes local testing annoying

SHELL := /bin/bash

domain := http://www.alicemaz.com/
makefile := Makefile

html_base := src/base
html_nav := src/nav
html_pages := $(wildcard src/pages/*)
html_out := $(addprefix build/,$(notdir $(html_pages:%=%.html)))

error_base := src/error
error_pages := $(wildcard src/errors/*)
error_out:= $(addprefix build/,$(notdir $(error_pages:%=%.html)))

make_page := src/makefile
make_out := build/makefile.html

twines := $(wildcard twine/*.html)

sitemap_base := src/sitemap/base
sitemap_block := src/sitemap/block
sitemap_out := build/sitemap.xml

now = date --rfc-3339=date
last_mod = $(now) -r $(1)
pretty_datetime = date +%d\ %b\ %H:%M:%S

.PHONY: all deploy clean

all: $(html_out) $(make_out) $(error_out) $(sitemap_out)
	@true

$(make_out): $(make_page) $(makefile) $(html_base) $(html_nav)
	@mkdir -p $(@D)
	@sed -e 's/xTITLE/<title>alice maz - makefile<\/title>/' \
		-e "/xNAV/r $(html_nav)" \
		-e "/xNAV/d" \
		-e "/xPAGE/r $<" \
		-e "/xPAGE/d" \
		-e 's/xJUMPTOP/$(@F)#/' \
		-e 's/xBOT/$(shell $(now))/' \
		-e 's/xMAKE/make/' $(html_base) | \
	sed -e "/xMAKEFILE/r $(makefile)" \
		-e "/xMAKEFILE/d" \
		-e 's/^\s*//' | \
	sed -e '/^<code>$$/,/^<\/code>$$/{/^<code>$$/b;/^<\/code>$$/b;s/</\&lt;/g;s/>/\&gt;/g}' > $@
	@printf "($(shell $(pretty_datetime))) made $(@F)\n"

build/%.html: src/pages/% $(html_base) $(html_nav)
	@mkdir -p $(@D)
	@ln -sf ../assets/ $(@D)
	@ln -sf ../twine/ $(@D)
	@ln -sf ../favicon.ico $(@D)
	$(eval pretty_name := $(shell [[ $(<F) == 'index' ]] && echo 'home' || echo $(<F)))
	@sed -e "s/xTITLE/<title>alice maz - $(pretty_name)<\/title>/" \
		-e "/xNAV/r $(html_nav)" \
		-e "/xNAV/d" \
		-e "/xPAGE/r $<" \
		-e "/xPAGE/d" \
		-e 's/xJUMPTOP/$(@F)#/' \
		-e 's/xBOT/$(shell $(now))/' \
		-e 's/xMAKE/<a href="makefile\.html">make<\/a>/' $(html_base) | \
	sed -e "/\"$(<F)\.html\"/c\<li>"$(pretty_name)"<\/li>" \
		-e 's/^\s*//' > $@
	@printf "($(shell $(pretty_datetime))) made $(@F)\n"

build/%.html: src/errors/% $(error_base)
	@mkdir -p $(@D)
	@sed -e "s/xTITLE/<title>alice maz - $(<F)<\/title>/" \
		-e "s/xH1/<h1>$(<F)<\/h1>/" \
		-e "/xPAGE/r $<" \
		-e "/xPAGE/d" \
		-e 's/xBOT/$(shell $(now))/' \
		-e 's/xMAKE/<a href="makefile\.html">make<\/a>/' $(error_base) | \
	sed -e 's/^\s*//' > $@
	@printf "($(shell $(pretty_datetime))) made $(@F)\n"

$(sitemap_out): $(html_out) $(make_out) $(twines)
	@rm -rf $@
	$(eval index := build/index.html)
	@sed -n '1,2p' $(sitemap_base) >> $@
	@sed -e 's/xLOC//' \
		-e 's|xMOD|$(shell $(call last_mod,$(index)))|' \
		-e 's/xPRIORITY/0\.8/' $(sitemap_block) >> $@
	$(eval loop = $(foreach page,$(filter-out $(index),$^),\
		sed -e 's|xLOC|$(shell [[ $(dir $(page)) == 'build/' ]] && \
			echo $(notdir $(page)) || echo $(page))|' \
			-e 's|xMOD|$(shell $(call last_mod,$(page)))|' \
			-e 's/xPRIORITY/0\.5/' $(sitemap_block);))
	@eval "$(loop)" >> $@
	@sed -n '3p' $(sitemap_base) >> $@
	@printf "($(shell $(pretty_datetime))) made $(@F)\n"

deploy:
	@$(MAKE)
	@rsync -rvLptWc --stats --progress --del -e ssh \
		build/ kitchen@salacia:/usr/local/www/site
	@printf "($(shell $(pretty_datetime))) deployed build/\n"

clean:
	@rm -rf build/
	@printf "($(shell $(pretty_datetime))) unmade build/\n"
