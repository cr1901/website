# TODO deploy recipe
# scp? rsync? git? think about it

# TODO test recipe
# easy, there's plenty of html validators on npm I'm sure
# few simple custom things like make sure no xVAR in build files etc
# ooo automatic spellcheck would be neat too

# TODO clean up duplicate code
# need to learn depend chains
# make_out in particular is like, 80% yankput from the main recipe

# TODO since the makefile now has a recipe that depends on itself...
# could I write a recipe to have it validate itself before touching files?
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

now = date --rfc-3339=date
last_mod = $(now) -r $(1)
pretty_datetime = date +%d\ %b\ %H:%M:%S

.PHONY: all clean

all: $(html_out) $(make_out) $(error_out) $(sitemap_out)
	@true

$(make_out): $(make_page) $(makefile) $(html_base) $(html_nav)
	@mkdir -p $(@D)
	@m4 -DxTITLE="<title>alice maz - makefile</title>" \
		-DxNAV=$(html_nav) \
		-DxPAGE=$< \
		-DxJUMPTOP=$(@F)"#" \
		-DxBOT=$(shell $(now)) \
		-DxMAKE=make \
		-DxMAKEFILE=$(makefile) $(html_base) | \
	sed -e 's/^\s*//' | \
	sed -e '/^<code>$$/,/^<\/code>$$/{/^<code>$$/b;/^<\/code>$$/b;s/</\&lt;/g;s/>/\&gt;/g}' > $@
	@printf "($(shell $(pretty_datetime))) made $(@F)\n"

build/%.html: src/pages/% $(html_base) $(html_nav)
	@mkdir -p $(@D)
	cp -rf ./assets/ $(@D)
	#@ln -sf ../assets/ $(@D)
	#@ln -sf ../twine/ $(@D)
	$(eval pretty_name := $(shell [[ $(<F) == 'index' ]] && echo 'home' || echo $(<F)))
	@m4 -DxTITLE="<title>WDJ - "$(pretty_name)"</title>" \
		-DxNAV=$(html_nav) \
		-DxPAGE=$< \
		-DxJUMPTOP=$(@F)"#" \
		-DxBOT=$(shell $(now)) \
		-DxMAKE="<a href=\"makefile.html\">make</a>" $(html_base) | \
	sed -e "/\"$(<F)\.html\"/c\<li>"$(pretty_name)"<\/li>" \
	 	-e 's/^\s*//' > $@
	@printf "($(shell $(pretty_datetime))) made $(@F)\n"

build/%.html: src/errors/% $(error_base)
	@mkdir -p $(@D)
	@m4 -DxTITLE="<title>alice maz - "$(<F)"</title>" \
		-DxH1="<h1>"$(<F)"</h1>" \
		-DxPAGE=$< \
		-DxBOT=$(shell $(now)) \
		-DxMAKE="<a href=\"makefile.html\">make</a>" $(error_base) | \
	sed -e 's/^\s*//' > $@
	@printf "($(shell $(pretty_datetime))) made $(@F)\n"

$(sitemap_out): $(html_out) $(make_out) $(twines)
	@rm -rf $@
	$(eval index := build/index.html)
	@sed -n '1,2p' $(sitemap_base) >> $@
	@m4 -DxLOC="" \
	-DxMOD=$(shell $(call last_mod,$(index))) \
	-DxPRIORITY=0.8 $(sitemap_block) >> $@
	$(eval loop = $(foreach page,$(filter-out $(index),$^),\
		m4 -DxLOC=$(shell [[ $(dir $(page)) == 'build/' ]] && \
			echo $(notdir $(page)) || echo $(page)) \
			-DxMOD=$(shell $(call last_mod,$(page))) \
			-DxPRIORITY=0.5 $(sitemap_block);))
	@eval "$(loop)" >> $@
	@sed -n '3p' $(sitemap_base) >> $@
	@printf "($(shell $(pretty_datetime))) made $(@F)\n"

clean:
	@rm -rf build/
	@printf "($(shell $(pretty_datetime))) unmade build/\n"
