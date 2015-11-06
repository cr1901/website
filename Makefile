# TODO presently my makefile does nothing if base or nav change
# tried a few approaches but nothing yet
# depending on build/ never triggered
# depending on $(html_out) made the main rule unreachable
# for now just `make clean` by hand, it's not like they'll change often
# but figure it out

SHELL := /bin/bash
THIS_FILE := $(lastword $(MAKEFILE_LIST))

domain := http://www.alicemaz.com/

html_base := src/base
html_nav := src/nav
html_pages := $(wildcard src/pages/*)
html_out := $(addprefix build/,$(notdir $(html_pages:%=%.html)))

twines := $(wildcard twine/*.html)

sitemap_base := src/sitemap/base
sitemap_block := src/sitemap/block
sitemap_out := build/sitemap.xml

last_mod = date --rfc-3339=date -r $(1)

.PHONY: all clean

all: $(html_out) $(sitemap_out)
	@true

build/%.html: src/pages/%
	@mkdir -p $(dir $@)
	@ln -sf ../assets/ $(dir $@)
	@ln -sf ../twine/ $(dir $@)
	$(eval name := $(notdir $<))
	$(eval pretty_name := $(shell [[ $(name) == 'index' ]] && echo 'home' || echo $(name)))
	@sed -e "s/\$$TITLE/<title>alice maz - $(pretty_name)<\/title>/" \
		-e "/\$$NAV/ {r $(html_nav)" \
		-e 'd}' \
		-e "/\$$PAGE/ {r $<" \
		-e 'd}' $(html_base) | \
	sed -e "/\"$(name)\.html\"/c\<li>"$(pretty_name)"<\/li>" \
		-e 's/^\s*//' > $@
	@printf "($(shell date +%d\ %b\ %H:%M:%S)) made $(notdir $@)\n"

$(sitemap_out): $(html_out)
	@rm -rf $@
	@sed -n '1,2p' $(sitemap_base) >> $@
	$(eval loop = $(foreach twine,$(twines),\
		sed -e 's|xLOC|$(twine)|' \
			-e 's|xMOD|$(shell $(call last_mod,$(twine)))|' \
			-e 's/xPRIORITY/0\.5/' $(sitemap_block);))
	@eval "$(loop)" >> $@
	@sed -n '3p' $(sitemap_base) >> $@
	@printf "($(shell date +%d\ %b\ %H:%M:%S)) made $(notdir $@)\n"

clean:
	@rm -rf build/
	@printf "($(shell date +%d\ %b\ %H:%M:%S)) unmade build/\n"
