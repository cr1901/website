# TODO deploy recipe
# scp? rsync? git? think about it

# TODO test recipe
# easy, there's plenty of html validators on npm I'm sure
# few simple custom things like make sure no xVAR in build files etc

# TODO clean up duplicate code
# need to learn depend chains
# make_out in particular is like, 80% yankput from the main recipe

# TODO strip the makefile.html link on its own page

# FIXME just occurred to me... makeout breaks while true make
# interesting consequence of the makefile having a recipe that depends on itself
# that's... hm. I'm not sure what to do about that
# oh man could I write a recipe to have it validate itself before touching files??
# that would be sick, look into that

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

pretty_datetime = date +%d\ %b\ %H:%M:%S
last_mod = date --rfc-3339=date -r $(1)
last_mod_p = date --rfc-3339=date

.PHONY: all clean

all: $(html_out) $(make_out) $(error_out) $(sitemap_out)
	@true

$(make_out): $(make_page) $(makefile) $(html_base) $(html_nav)
	@mkdir -p $(@D)
	@sed -e 's/xTITLE/<title>alice maz - makefile<\/title>/' \
		-e "/xNAV/ r $(html_nav)" \
		-e "/xNAV/ d" \
		-e "/xPAGE/ r $<" \
		-e "/xPAGE/ d" \
		-e 's/xJUMPTOP/$(@F)#/' \
		-e 's/xBOT/$(shell $(last_mod_p))/' \
		-e 's/xMAKE/make/' $(html_base) | \
	sed -e "/xMAKEFILE/ r $(makefile)" \
		-e "/xMAKEFILE/ d" \
		-e 's/^\s*//' | \
	sed -e '/<code>/,/<\/code>/{/^<code>$$/b;/^<\/code>$$/b;s/</\&lt;/g;s/>/\&gt;/g}' > $@
	@printf "($(shell $(pretty_datetime))) made $(@F)\n"

build/%.html: src/pages/% $(html_base) $(html_nav)
	@mkdir -p $(@D)
	@ln -sf ../assets/ $(@D)
	@ln -sf ../twine/ $(@D)
	$(eval pretty_name := $(shell [[ $(<F) == 'index' ]] && echo 'home' || echo $(<F)))
	@sed -e "s/xTITLE/<title>alice maz - $(pretty_name)<\/title>/" \
		-e "/xNAV/ r $(html_nav)" \
		-e "/xNAV/ d" \
		-e "/xPAGE/ r $<" \
		-e "/xPAGE/ d" \
		-e 's/xJUMPTOP/$(@F)#/' \
		-e 's/xBOT/$(shell $(last_mod_p))/' \
		-e 's/xMAKE/<a href="makefile\.html">make<\/a>/' $(html_base) | \
	sed -e "/\"$(<F)\.html\"/c\<li>"$(pretty_name)"<\/li>" \
		-e 's/^\s*//' > $@
	@printf "($(shell $(pretty_datetime))) made $(@F)\n"

build/%.html: src/errors/% $(error_base)
	@mkdir -p $(@D)
	@sed -e "s/xTITLE/<title>alice maz - $(<F)<\/title>/" \
		-e "s/xH1/<h1>$(<F)<\/h1>/" \
		-e "/xPAGE/ r $<" \
		-e "/xPAGE/ d" \
		-e 's/xBOT/$(shell $(last_mod_p))/' \
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

clean:
	@rm -rf build/
	@printf "($(shell $(pretty_datetime))) unmade build/\n"
