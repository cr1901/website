# TODO blog platform
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

domain := https://www.alicemaz.com/
makefile := Makefile

html_base := src/base
html_nav := src/nav
html_pages := $(wildcard src/pages/*)
html_out := $(addprefix build/,$(notdir $(html_pages:%=%.html)))

error_base := src/error
error_pages := $(wildcard src/errors/*)
error_out:= $(addprefix build/,$(notdir $(error_pages:%=%.html)))

makefile_staging := staging/makefile
make_page_staging := staging/pages/makefile.html
make_out := build/makefile.html

twines := $(wildcard twine/*.html)

sitemap_first := src/sitemap/first
sitemap_last := src/sitemap/last
sitemap_block := src/sitemap/block
sitemap_staging := staging/sitemap/index \
	$(addprefix staging/sitemap/pages/,$(filter-out index,$(notdir $(html_pages)))) \
	$(addprefix staging/sitemap/,$(twines:%.html=%))
sitemap_out := build/sitemap.xml

now = date --rfc-3339=date
last_mod = $(now) -r $(1)
pretty_datetime = date +%d\ %b\ %H:%M:%S

.PHONY: all deploy clean
.INTERMEDIATE: $(make_page_staging) $(makefile_staging)

all: $(html_out) $(error_out) $(sitemap_out)
	@true


###########
# staging #
###########

$(makefile_staging): $(makefile)
	@mkdir -p $(@D)
	@sed 's/</\&lt;/g;s/>/\&gt;/g;' $< > $@
	@printf "($(shell $(pretty_datetime))) staged $(@F)\n"

staging/sitemap/index: src/pages/index $(sitemap_block)
	@mkdir -p $(@D)
	@m4 -D xLOC \
		-D xMOD=$(shell $(call last_mod,$<)) \
		-D xFREQ=daily \
		-D xPRIORITY=0.9 $(sitemap_block) > $@

staging/sitemap/pages/%: src/pages/% $(sitemap_block)
	@mkdir -p $(@D)
	@m4 -D xLOC=$(@F) \
		-D xMOD=$(shell $(call last_mod,$<)) \
		-D xFREQ=daily \
		-D xPRIORITY=0.7 $(sitemap_block) > $@

staging/sitemap/twine/%: twine/%.html $(sitemap_block)
	@mkdir -p $(@D)
	@m4 -D xLOC=$< \
		-D xMOD=$(shell $(call last_mod,$<)) \
		-D xFREQ=monthly \
		-D xPRIORITY=0.3 $(sitemap_block) > $@

staging/pages/%.html: src/pages/% $(html_base) $(html_nav)
	@mkdir -p $(@D)
	
	$(eval pretty_name := $(shell [[ $(<F) == 'index' ]] && \
		echo 'home' || ([[ $(<F) == 'makefile' ]] && \
		echo 'make' || echo $(<F))))
	$(eval href_name := $(shell [[ $(<F) == 'index' ]] && \
		echo '/' || echo $(<F).html))
	
	@m4 -D xTITLE='<title>alice maz - $(pretty_name)</title>' \
		-D xNAV=$(html_nav) \
		-D xPAGE=$< \
		-D xJUMPTOP=$(@F)'#' \
		-D xBOT=$(shell $(now)) \
		-D xMAKE='<a href="makefile.html">make</a>' $(html_base) | \
	sed -e 's|<a href="$(href_name)">$(pretty_name)</a>|$(pretty_name)|g' \
		-e 's/^\s*//' > $@
	
	@printf "($(shell $(pretty_datetime))) staged $(@F)\n"

staging/pages/%.html: src/errors/% $(error_base)
	@mkdir -p $(@D)
	
	@m4 -D xTITLE='<title>alice maz - $(<F)</title>' \
		-D xH1='<h1>$(<F)</h1>' \
		-D xPAGE=$< \
		-D xJUMPTOP=$(@F)'#' \
		-D xBOT=$(shell $(now)) \
		-D xMAKE='<a href="makefile.html">make</a>' $(error_base) | \
	sed -e 's/^\s*//' > $@
	
	@printf "($(shell $(pretty_datetime))) staged $(@F)\n"


###########
#  build  #
###########

$(sitemap_out): $(sitemap_first) $(sitemap_staging) $(sitemap_last)
	@cat $^ > $@
	@printf "($(shell $(pretty_datetime))) made $(@F)\n"

$(make_out): $(make_page_staging) $(makefile_staging)
	@mkdir -p $(@D)
	@m4 -D xMAKEFILE=$(makefile_staging) $< > $@
	@printf "($(shell $(pretty_datetime))) made $(@F)\n"

build/%.html: staging/pages/%.html
	@mkdir -p $(@D)
	@ln -sf ../assets/ $(@D)
	@ln -sf ../twine/ $(@D)
	@ln -sf ../favicon.ico $(@D)
	@cp -r $< $@
	@printf "($(shell $(pretty_datetime))) made $(@F)\n"

deploy:
	@$(MAKE)
	@rsync -rvLptWc --stats --progress --del -e ssh \
		build/ kitchen@salacia:/usr/local/www/site
	@printf "($(shell $(pretty_datetime))) deployed build/\n"

clean:
	@rm -rf staging/
	@rm -rf build/
	@printf "($(shell $(pretty_datetime))) unmade build/\n"
