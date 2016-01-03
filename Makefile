# TODO blog platform
# staging step transforms markdown posts into html, spellcheck, etc
# write out excerpts, xVAR, removed from full post, sliced for previews
# builds dynamic elements like whatever blog links to blog things
# eg "recent posts" list, category page, tag page, calendar page
# build step inserts post into template like makefile.html does
# inserts excerpt blocks into main/history-style "next 10" pages

SHELL := /bin/bash
MAKEFLAGS := s

domain := https://www.alicemaz.com/
makefile := Makefile

html_base := src/base.m4
html_nav := src/nav.m4
html_index := src/pages/index.m4
html_pages := $(wildcard src/pages/*.m4)
html_out := $(addprefix build/,$(notdir $(html_pages:%.m4=%.html)))

error_base := src/error.m4
error_pages := $(wildcard src/errors/*.m4)
error_out:= $(addprefix build/,$(notdir $(error_pages:%.m4=%.html)))

makefile_staging := staging/makefile
make_page_staging := staging/pages/makefile.html
make_out := build/makefile.html

twines := $(wildcard twine/*.html)

sitemap_first := src/sitemap/first.m4
sitemap_last := src/sitemap/last.m4
sitemap_block := src/sitemap/block.m4
sitemap_staging := staging/sitemap/index \
	$(addprefix staging/sitemap/pages/, \
		$(filter-out index,$(basename $(notdir $(html_pages))))) \
	$(addprefix staging/sitemap/,$(twines:%.html=%))
sitemap_out := build/sitemap.xml

tweet_base := src/twitter/base.m4
tweet_pages := $(wildcard src/twitter/tweets/*.m4)
tweet_staging := $(addprefix staging/tweets/,$(basename $(notdir $(tweet_pages))))
bot_page_staging := staging/pages/bots.html
bot_gameboard := src/twitter/gameboard.m4
bots_out := build/bots.html

now = date --rfc-3339=date
last_mod = $(now) -r $(1)
pretty_datetime = date +%d\ %b\ %H:%M:%S

.PHONY: all localhref remotehref deploy unstage unbuild clean
.INTERMEDIATE: $(make_page_staging) $(makefile_staging) $(bot_page_staging) $(tweet_staging)


###########
#  make   #
###########

all: $(html_out) $(error_out) $(sitemap_out)


###########
# staging #
###########

$(makefile_staging): $(makefile)
	mkdir -p $(@D)
	sed 's/</\&lt;/g;s/>/\&gt;/g;' $< > $@
	printf "($(shell $(pretty_datetime))) staged $(@F)\n"

staging/sitemap/index: $(html_index) $(sitemap_block)
	mkdir -p $(@D)
	m4 -D xLOC \
		-D xMOD=$(shell $(call last_mod,$<)) \
		-D xFREQ=daily \
		-D xPRIORITY=0.9 $(sitemap_block) > $@

staging/sitemap/pages/%: src/pages/%.m4 $(sitemap_block)
	mkdir -p $(@D)
	m4 -D xLOC=$(@F).html \
		-D xMOD=$(shell $(call last_mod,$<)) \
		-D xFREQ=daily \
		-D xPRIORITY=0.7 $(sitemap_block) > $@

staging/sitemap/twine/%: twine/%.html $(sitemap_block)
	mkdir -p $(@D)
	m4 -D xLOC=$< \
		-D xMOD=$(shell $(call last_mod,$<)) \
		-D xFREQ=monthly \
		-D xPRIORITY=0.3 $(sitemap_block) > $@

staging/tweets/%: src/twitter/tweets/%.m4 $(tweet_base)
	mkdir -p $(@D)
	$(eval acct := $(shell echo '$<' | \
		sed -e 's/\<tweets\>/accounts/' -e 's/-[0-9]\+//'))
	m4 -D xACCT=$(acct) -D xTWEET=$< $(tweet_base) | \
	sed -e 's/^\s*//' > $@

staging/pages/%.html: src/pages/%.m4 $(html_base) $(html_nav)
	mkdir -p $(@D)
	
	$(eval stem := $(basename $(<F)))
	$(eval pretty_name := $(shell [[ $(stem) == 'index' ]] && \
		echo 'home' || ([[ $(stem) == 'makefile' ]] && \
		echo 'make' || echo $(stem))))
	$(eval href_name := $(shell [[ $(stem) == 'index' ]] && \
		echo '/' || echo $(stem).html))
	
	m4 -D xTITLE='<title>WDJ - "$(pretty_name)"</title>' \
		-D xNAV=$(html_nav) \
		-D xPAGE=$< \
		-D xJUMPTOP=$(@F)'#' \
		-D xBOT=$(shell $(now)) \
		-D xMAKE='<a href="makefile.html">make</a>' $(html_base) | \
	sed -e 's|<a href="$(href_name)">$(pretty_name)</a>|$(pretty_name)|g' \
		-e 's/^\s*//' > $@
	
	printf "($(shell $(pretty_datetime))) staged $(@F)\n"

staging/pages/%.html: src/errors/%.m4 $(error_base)
	mkdir -p $(@D)
	
	$(eval stem := $(basename $(<F)))
	
	m4 -D xTITLE='<title>WDJ - $(stem)</title>' \
		-D xH1='<h1>$(stem)</h1>' \
		-D xPAGE=$< \
		-D xJUMPTOP=$(@F)'#' \
		-D xBOT=$(shell $(now)) \
		-D xMAKE='<a href="makefile.html">make</a>' $(error_base) | \
	sed -e 's/^\s*//' > $@
	
	printf "($(shell $(pretty_datetime))) staged $(@F)\n"


###########
#  build  #
###########

$(sitemap_out): $(sitemap_first) $(sitemap_staging) $(sitemap_last)
	mkdir -p $(@D)
	cat $^ > $@
	printf "($(shell $(pretty_datetime))) made $(@F)\n"

$(make_out): $(make_page_staging) $(makefile_staging)
	mkdir -p $(@D)
	m4 -D xMAKEFILE=$(makefile_staging) $< > $@
	printf "($(shell $(pretty_datetime))) made $(@F)\n"

$(bots_out): $(tweet_staging) $(bot_page_staging) $(bot_gameboard)
	mkdir -p $(@D)
	m4 -D xGAMEBOARD=$(bot_gameboard) -I $(<D) $(bot_page_staging) > $@
	printf "($(shell $(pretty_datetime))) made $(@F)\n"

build/%.html: staging/pages/%.html
	mkdir -p $(@D)
	ln -sf ../assets/ $(@D)
	ln -sf ../twine/ $(@D)
	ln -sf ../favicon.ico $(@D)
	ln -sf ../robots.txt $(@D)
	cp -r $< $@
	printf "($(shell $(pretty_datetime))) made $(@F)\n"


###########
#  tasks  #
###########

localhref:
	for f in build/*.html; do \
		sed -i 's|^\(<base href="\)$(domain)\(">\)$$|\1/\2|' $$f; \
		done
	printf "($(shell $(pretty_datetime))) base href to local\n"

remotehref:
	for f in build/*.html; do \
		sed -i 's|^\(<base href="\)/\(">\)$$|\1$(domain)\2|' $$f; \
		done
	printf "($(shell $(pretty_datetime))) base href to remote\n"

deploy:
	$(MAKE)
	$(MAKE) remotehref
	rsync -rvLptWc --stats --progress --del -e ssh \
		build/ kitchen@salacia:/usr/local/www/site
	printf "($(shell $(pretty_datetime))) deployed build/\n"
	$(MAKE) localhref

unstage:
	rm -rf staging/
	printf "($(shell $(pretty_datetime))) unmade staging/\n"

unbuild:
	rm -rf build/
	printf "($(shell $(pretty_datetime))) unmade build/\n"
>>>>>>> 8a02209c57a8dadf170747cfdff551d3a2a3f1ff

clean:
	$(MAKE) unstage
	$(MAKE) unbuild
