PATH := node_modules/.bin:$(PATH)
SHELL := /bin/bash

html_base := src/base
html_nav := src/nav
html_pages := $(wildcard src/pages/*)

html_out := build/$(notdir $(html_pages:%=%.html))

.PHONY: all clean

all: $(html_out)

build/%.html: src/pages/%
	@mkdir -p $(dir $@)
	$(eval name := $(notdir $<))
	$(eval pretty_name := $(shell [[ $(name) == 'index' ]] && echo 'home' || echo $(name)))
	sed -e "s/\$$TITLE/<title>alice maz - $(pretty_name)<\/title>/" \
		-e "/\$$NAV/ {r $(html_nav)" \
		-e 'd}' \
		-e "/\$$PAGE/ {r $<" \
		-e 'd}' $(html_base) | \
	sed "/\"$(name)\.html\"/c\<li>"$(pretty_name)"<\/li>" | \
	sed 's/^\s*//' > $@

clean:
	rm -rf build/
