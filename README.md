this is the repo for my site. basically it works like an ssg: I write what are essentially templates and views, build them on my dev machine resulting in the entire site as it will exist on the internets, then deploy it to the server. except instead of using fun tools with quirky names like grunt and jeckyl and travis, I use make, sed, and rsync.

actually the only reason I'm writing a readme is to test my post-update hook that does readme markdown parsing sorry

# Header
## Subheader

text *bold* _ital_ [link](https://www.alicemaz.com)

* bullet
* point

1. numbered
2. list

>block
>
>quote

	printf("code block%c\n",'!');
	return 0;

...the Aristocrats!
