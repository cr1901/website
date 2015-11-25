define(`xBARB0', ``include(barb-0)'')dnl
define(`xBARB1', ``include(barb-1)'')dnl
define(`xBARB2', ``include(barb-2)'')dnl
define(`xKNOCK0', ``include(knock-0)'')dnl
define(`xKNOCK1', ``include(knock-1)'')dnl
define(`xKNOCK2', ``include(knock-2)'')dnl
define(`xJEO0', ``include(jeo-0)'')dnl
define(`xJEO1', ``include(jeo-1)'')dnl
define(`xJEO2', ``include(jeo-2)'')dnl
define(`xJEO3', ``include(jeo-3)'')dnl
define(`xJEO4', ``include(jeo-4)'')dnl
define(`xJAJ0', ``include(jaj-0)'')dnl
define(`xJAJ1', ``include(jaj-1)'')dnl
define(`xJAJ2', ``include(jaj-2)'')dnl
define(`xIDEAL0', ``include(ideal-0)'')dnl
define(`xIDEAL1', ``include(ideal-1)'')dnl
define(`xIDEAL2', ``include(ideal-2)'')dnl
define(`xIDEAL3', ``include(ideal-3)'')dnl
define(`xNOUNS0', ``include(nouns-0)'')dnl
define(`xNOUNS1', ``include(nouns-1)'')dnl
define(`xNOUNS2', ``include(nouns-2)'')dnl
define(`xNOUNS3', ``include(nouns-3)'')dnl
define(`xGOOG0', ``include(goog-0)'')dnl
define(`xGOOG1', ``include(goog-1)'')dnl
define(`xGOOG2', ``include(goog-2)'')dnl
define(`xGOOG3', ``include(goog-3)'')dnl
define(`xGOOG4', ``include(goog-4)'')dnl
define(`xMASS', ``include(mass-0)'')dnl
<div id="main" class="bots" role="main">

	<div id="fauna">
		xNOUNS0
		xNOUNS1
		xNOUNS2
		xNOUNS3
		
		<dl>
			<dt><a href="https://twitter.com/plural_fauna">@plural_fauna</a></dt>
			<dd>ex-jokebot. originally this was @omfg_animals, a bot that tweeted ~unbelievable~ animal facts, but with the animals swapped out, along with the occasional "a group of $ANIMALs is called a $NOUN". the former got old quick, but the latter was more often poetic than amusing, so I changed the template sentence, changed one line of code, and made this. vastly improved.</dd>
		</dl>
	</div>

	<div id="googling">
		xGOOG0
		xGOOG1
		xGOOG2
		xGOOG3
		xGOOG4
		
		<dl>
			<dt><a href="https://twitter.com/alice_googling">@alice_googling</a></dt>
			<dd>markov chains made from about a year of my google search history. interesting to me because I can read the composites and remember what I'd actually searched to generate those ngrams. not nearly the bare-my-soul art project I'd expected it to be. it turns out I mostly just google programming stuff.</dd>
			<dd>the search history corpus hasn't been updated since I made it, I'm very careful to redact other people's information, and doing so is a chore. when the convenience of having my past searches available is finally outweighed by my privacy paranoia, I will likely update this bot a second time and stop searching over the clearnet for good.</dd>
		</dl>
	</div>

	<div id="connect4">
		xMASS
		
		<dl>
			<dt><a href="https://twitter.com/massconnect4">@massconnect4</a></dt>
			<dd>asdf</dd>
		</dl>
	</div>

	<div id="jajlang">
		xJAJ0
		xJAJ1
		xJAJ2
		
		<dl>
			<dt><a href="https://twitter.com/jajlang">@jajlang</a></dt>
			<dd>topical jokebot. I was very angry when scotus refused cert on oracle v. google. an api is clearly a method of operation in exactly the same way that a user interface is, and despite the fact that it is a legitimate create work, allowing copyright unduly burdens users. lotus v. borland. at least it's only federal circuit.</dd>
			<dd>anyway so I made this thing. it has every method of every class in about a half-dozen packages, splits out the words, deduplicates, checks for synonyms, puts them back in place and fixes the caps. could be the basis of the worst trivia night in the world.</dd>
		</dl>
	</div>

	<div id="knock2">
		xKNOCK0
		xKNOCK1
		xKNOCK2
		
		<dl>
			<dt><a href="https://twitter.com/knock2bot">@knock2bot</a></dt>
			<dd>jokebot (obviously). makes me laugh more often than I'd like to admit. chooses one random word, then finds a bigram phrase containing it.</dd>
		</dl>
	</div>

	<div id="jeopardy">
		xJEO0
		xJEO1
		xJEO2
		xJEO3
		xJEO4

		<dl>
			<dt><a href="https://twitter.com/super_jeopardy">@super_jeopardy</a></dt>
			<dd>jokebot. pulls two jeopardy questions out of a corpus, splits the strings on (articles|conjunctions|prepositions), combines arrays, drops substrings from the middle until the character count goes below 140, and joins. this isn't a bad method, turns out: because you're working with fragments of natural language, and because you're starting with a start of a sentence and ending with an end, results tend to be more coherent than say markoving the text.</dd>
			<dd>still, not quite right. you can see the seams, and most of what it produces doesn't make sense as a jeopardy question. I think about revisiting it every now and then (certainly I'd make it so the word "this" occurs precisely once in a well-formed result) but I doubt I will.</dd>
			<dd>I was cagey on the account page about it being a bot in the hopes that actualy jeopardy fans would think it was legitimate and follow. they do, though they usually unfollow pretty quickly.</dd>
		</dl>
	</div>

	<div id="barbossa">
		xBARB0
		xBARB1
		xBARB2

		<dl>
			<dt><a href="https://twitter.com/believebarbossa">@believebarbossa</a></dt>
			<dd>jokebot. my first, and the trivial-but-doable project that got me back into programming, so it holds a special place in my heart. words chosen at random. with eternal thanks to darius kazemi.</dd>
		</dl>
	</div>

	<div id="consumer">
		xIDEAL0
		xIDEAL1
		xIDEAL2
		xIDEAL3

		<dl>
			<dt><a href="https://twitter.com/consumer_ideal">@consumer_ideal</a></dt>
			<dd>jokebot. on hiatus, probably retired. tweets every twitter analytics category, determining which to tweet based on the percentages listed in the twitter analytics data. also it tweets disparaging accusations about random fortune 500 companies. I think I thought it was a clever statement or something.</dd>
		</dl>
	</div>

	<p>experimenting with tweet display. not planning on populating the page by hand though. while this page is under construction, here is a <a href="https://twitter.com/alicemazzy/lists/my-bots">list of most of my bots</a>.</p>

	<p><img style="border:none;" src="assets/img/const.gif"><br/></p>
</div>

<div id="side" role="navigation">
	<h2>jump</h2>

	<ul>
		<li><a href="bots.html#botmistress">botmistress</a></li>
		<li><a href="bots.html#googling">googling</a></li>
		<li><a href="bots.html#fauna">fauna</a></li>
		<li><a href="bots.html#jajlang">jajlang</a></li>
		<li><a href="bots.html#knock2">knock2</a></li>
		<li><a href="bots.html#jeopardy">jeopardy</a></li>
		<li><a href="bots.html#barbossa">barbossa</a></li>
		<li><a href="bots.html#consumer">consumer</a></li>
	</ul>
</div>
