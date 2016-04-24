# TODO blog platform
# staging step transforms markdown posts into html, spellcheck, etc
# write out excerpts, xVAR, removed from full post, sliced for previews
# builds dynamic elements like whatever blog links to blog things
# eg "recent posts" list, category page, tag page, calendar page
# build step inserts post into template like makefile.html does
# inserts excerpt blocks into main/history-style "next 10" pages

SHELL := /bin/bash
MAKEFLAGS := s

domain := https://www.wdj-consulting.com/
makefile := Makefile

html_base := src/base.m4
html_nav := src/nav.m4
html_index := src/pages/index.m4
html_pages := $(wildcard src/pages/*.m4)
html_out := $(addprefix build/,$(notdir $(html_pages:%.m4=%.html)))

error_base := src/error.m4
error_pages := $(wildcard src/errors/*.m4)
error_out:= $(addprefix build/,$(notdir $(error_pages:%.m4=%.html)))

blog_base := src/blog.m4
blog_nav := src/blognav.m4
blog_pages := $(wildcard src/blog/*.m4)
# TODO: DO not hardcode blog prefix?
blog_out:= $(addprefix build/blog/,$(notdir $(blog_pages:%.m4=%.html)))

makefile_staging := staging/makefile
make_page_staging := staging/pages/makefile.html
make_out := build/makefile.html

sitemap_first := src/sitemap/first.m4
sitemap_last := src/sitemap/last.m4
sitemap_block := src/sitemap/block.m4
sitemap_staging := staging/sitemap/index \
	$(addprefix staging/sitemap/pages/, \
		$(filter-out index,$(basename $(notdir $(html_pages))))) \
	$(addprefix staging/sitemap/blog/, $(basename $(notdir $(blog_pages))))
sitemap_out := build/sitemap.xml

now = date --rfc-3339=date
last_mod = $(now) -r $(1)
pretty_datetime = date +%d\ %b\ %H:%M:%S

.PHONY: all localhref remotehref deploy unstage unbuild clean
.INTERMEDIATE: $(make_page_staging) $(makefile_staging)


###########
#  make   #
###########

all: $(html_out) $(error_out) $(blog_out) $(sitemap_out)


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

# TODO: Don't hardcode the "blog" path?
staging/sitemap/blog/%: src/blog/%.m4 $(blog_nav) $(sitemap_block)
	mkdir -p $(@D)
	m4 -D xLOC=blog/$(@F).html \
		-D xMOD=$(shell $(call last_mod,$<)) \
		-D xFREQ=monthly \
		-D xPRIORITY=0.3 $(sitemap_block) > $@

# staging/tweets/%: src/twitter/tweets/%.m4 $(tweet_base)
# 	mkdir -p $(@D)
# 	$(eval acct := $(shell echo '$<' | \
# 		sed -e 's/\<tweets\>/accounts/' -e 's/-[0-9]\+//'))
# 	m4 -D xACCT=$(acct) -D xTWEET=$< $(tweet_base) | \
# 	sed -e 's/^\s*//' > $@

staging/pages/%.html: src/pages/%.m4 $(html_base) $(html_nav)
	mkdir -p $(@D)

	$(eval stem := $(basename $(<F)))
	$(eval pretty_name := $(shell [[ $(stem) == 'index' ]] && echo 'Home' || \
		([[ $(stem) == 'about' ]] && echo 'About' || \
		([[ $(stem) == 'makefile' ]] && echo 'Make' || \
		echo $(stem)))))
	$(eval href_name := $(shell [[ $(stem) == 'index' ]] && \
		echo '/' || echo $(stem).html))

	m4 -D xTITLE='<title>WDJ - "$(pretty_name)"</title>' \
		-D xNAV=$(html_nav) \
		-D xPATH_TO_ROOT=. \
		-D xPAGE=$< \
		-D xBOT=$(shell $(now)) \
		-D xMAKE='<a href="makefile.html">make</a>' $(html_base) | \
	sed -e 's|<a href="$(href_name)">$(pretty_name)</a>|<span id="curr_section">$(pretty_name)</span>|g' > $@

	printf "($(shell $(pretty_datetime))) staged $(@F)\n"

staging/pages/%.html: src/errors/%.m4 $(error_base)
	mkdir -p $(@D)

	$(eval stem := $(basename $(<F)))

	m4 -D xTITLE='<title>WDJ - $(stem)</title>' \
		-D xH1='<h1>$(stem)</h1>' \
		-D xPAGE=$< \
		-D xBOT=$(shell $(now)) \
		-D xMAKE='<a href="makefile.html">make</a>' $(error_base) > $@

	printf "($(shell $(pretty_datetime))) staged $(@F)\n"

staging/blog/%.html: src/blog/%.m4 $(blog_base) $(blog_nav)
	mkdir -p $(@D)

	$(eval stem := $(basename $(<F)))

	# TODO: Don't hardcode blog
	m4 -D xTITLE='<title>WDJ - $(stem)</title>' \
		-D xNAV=$(html_nav) \
		-D xBLOGNAV=$(blog_nav) \
		-D xPATH_TO_ROOT=.. \
		-D xPAGE=$< \
		-D xBOT=$(shell $(now)) \
		-D xMAKE='<a href="makefile.html">make</a>' $(blog_base) > $@

	printf "($(shell $(pretty_datetime))) staged $(@F)\n"

# Pages with special dependencies.
staging/pages/blog.html: src/pages/blog.m4  $(html_base) $(html_nav) $(blog_nav)
	mkdir -p $(@D)

	$(eval stem := $(basename $(<F)))
	$(eval pretty_name := 'Anachronism')
	$(eval href_name := $(stem).html)

	m4 -D xTITLE='<title>WDJ - "$(pretty_name)"</title>' \
		-D xNAV=$(html_nav) \
		-D xBLOGNAV=$(blog_nav) \
		-D xPATH_TO_ROOT=. \
		-D xPAGE=$< \
		-D xBOT=$(shell $(now)) \
		-D xMAKE='<a href="makefile.html">make</a>' $(html_base) | \
	sed -e 's|<a href="$(href_name)">$(pretty_name)</a>|<span id="curr_section">$(pretty_name)</span>|g' > $@


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

# TODO: Any way to put this into the build/%.html target?
build/blog/%.html: staging/blog/%.html assets/css/style.css
	mkdir -p $(@D)
	cp -r $< $@
	printf "($(shell $(pretty_datetime))) made $(@F)\n"

build/%.html: staging/pages/%.html assets/css/style.css
	mkdir -p $(@D)
	cp -rf assets build
	cp -f favicon.ico $(@D)
	cp -f robots.txt $(@D)
	cp -r $< $@
	printf "($(shell $(pretty_datetime))) made $(@F)\n"


###########
#  tasks  #
###########
deploy:
	$(MAKE)
	$(MAKE) remotehref
	scp -r build/* freebsd@wdj-consulting.com:/usr/local/www/site
	printf "($(shell $(pretty_datetime))) deployed build/\n"
	$(MAKE) localhref

unstage:
	rm -rf staging/
	printf "($(shell $(pretty_datetime))) unmade staging/\n"

unbuild:
	rm -rf build/
	printf "($(shell $(pretty_datetime))) unmade build/\n"

clean:
	$(MAKE) unstage
	$(MAKE) unbuild
