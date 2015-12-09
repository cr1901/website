<div id="main" role="main">
	<div class="news">
		<dl>
			<dt><time datetime="2015-12-08">2015-12-08</time></dt>

			<dd>so I started writing rust a week ago. very enjoyable thus far. functional goodness <em>and</em> I get to fiddle with pointers?? best of both worlds. the ecosystem is also really fresh, it's so exciting to look around and see all this work that needs to be done! look forward to doing some of it.</dd>
            <dd>part of my "learn the language" first project, I wrote code to do oauth 1.0a request signing. incidentally a great starter project, forces you to touch a lot of disparate parts of a new language--string manip, timestamps, crypto, http, data structures--just briefly, so you get a good overview of how everything fits together. I got annoyed I had to depend on an entire [de]serialization lib just to do base64, so I wrote a tiny thing that does base64. it's called <a href="https://github.com/alicemaz/rust-base64">base64</a>. also on <a href="https://crates.io/crates/base64">crates.io</a>. nothing fancy, but it was a fun diversion.</dd>
            <dd>besides that I finally got fed up enough with web twitter to start on my long-planned custom interface. with the fun name <a href="https://github.com/alicemaz/subtwitter">subtwitter</a>.</dd>
			<dd>
				<div id="main-img">
					<img alt="screenshot of a webpage containing three columns of tweets, with avatars, icons for common actions, and other helpful information" src="assets/img/subtwitter.png">
				</div>
			</dd>
            <dd>the core idea is a multi-column layout where, presently, the left column is the unfiltered timeline, right is mentions and direct messages, center is what I've been calling "the feed". the feed is meant to be a fluid thing, with simple controls to quickly combine and exclude lists of accounts, so you see just what you want and can swap things in and out on a whim. I've recently been made aware (as I probably should have guessed) that I'm replicating a lot of functionality from the old usenet readers. so that's encouraging, a sign I am aiming in the right direction.</dd>
            <dd>after that (and all the core twitter features of course), I plan on messing around with neural nets trained on my interactions with the service. lots of data, have lots of ideas. there's some unhinged rambling in <a href="https://github.com/alicemaz/subtwitter#whats-the-plan">the readme</a> where I hash out my goals.</dd>
            <dd>but, philosophically... rather than unaccountable moderation or opaque algorithms, I would like to see services that act as dumb pipe, where endpoints do all the filtering, and users have the freedom to apply or reject whatever rules they see fit. twitter is less than an ideal platform obviously, but the concepts can be applied to arbitrary networks. with all the old institutional filters collapsing, we become more discerning, and with the volume of data we process increasing and increasing, we need tools to help sort through it. this is my initial stab at building an understanding of how to accomplish all that.</dd>
            <dd>also, twistor, ha ha, did I say a week or two? I get distracted by the shinies easily, everything is so interesting. soon.</dd>
		</dl>

		<dl>
			<dt><time datetime="2015-11-22">2015-11-22</time></dt>

			<dd>this site now supports tls. yay! shoutout to the folks at <a href="https://letsencrypt.org/">letsencrypt</a>, truly they are doing the work of the goddess.</dd>
			<dd>note that presently git only works over http. alas, nothing I can do until my subdomains are whitelisted. for now I've just set https to git to 403, but if you happen upon a scary browser warning, that is why.</dd>
			<dd>ideally I will have a 1.0 of twistor up and running in a week or two. I migrated this site to a new host yesterday, and setting this server up takes care of most of what I'd need to do for that project.</dd>
		</dl>
		
		<dl>
			<dt><time datetime="2015-11-07">2015-11-07</time></dt>

			<dd>current project: <a href="https://github.com/alicemaz/twistor">twistor</a>, a site that archives and makes publicly viewable deleted tweets from politicians, and a small set of programs that enables others to do likewise with arbitrary twitter feeds.</dd>
			<dd>
				<div id="main-img">
					<img alt="screenshot of a webpage containing a table of tweets by politicians that they had deleted, their account information, information about the tweets, and a search bar" src="assets/img/twistor.png">
				</div>
			</dd>
		</dl>
	</div>
</div>
