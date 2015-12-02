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
define(`xHENGE', ``include(henge-0)'')dnl
define(`xPOTUS0', ``include(wh-0)'')dnl
define(`xPOTUS1', ``include(dod-0)'')dnl
define(`xPOTUS2', ``include(wh-1)'')dnl
define(`xPOTUS3', ``include(dhs-0)'')dnl
define(`xPOTUS4', ``include(chi-0)'')dnl
define(`xMISS0', ``include(miss-0)'')dnl
define(`xMISS1', ``include(miss-1)'')dnl
define(`xMISS2', ``include(miss-2)'')dnl
define(`xMISS3', ``include(miss-3)'')dnl
define(`xMISS4', ``include(miss-4)'')dnl
define(`xMISS5', ``include(miss-5)'')dnl
<div id="main" class="bots" role="main">

	<div id="botmistress">
		xMISS0
		xMISS1
		xMISS2
		xMISS3
		xMISS4
		xMISS5
		
		<dl>
			<dt><a href="https://twitter.com/botmistress">@botmistress</a> ~ <a href="https://git.alicemaz.com/public/?p=mistress.git;a=summary"><img class="git-icon" src="assets/img/git-icon.png"></a></dt>
			<dd>presently dormant. on her I pin my hopes. kind of a random account that I use for testing purposes and various experiments. ideally the goal is for her to be an extensible system I can plug functionality into until she achieves self-awareness. shodan v0.0.1. near the top of my reading list are "a field guide to genetic programming" and "handbook of neuroevolution through erlang". we will see how far I can take it.</dd>
			<dd>originally, she was a newbie project, a mess of state and switch-cases all inside a single function. I could tweet at her, things like "make henge follow me" or "make barbossa delete $ID", and she would make the api calls on their behalf. the codebase was a horrible mess, but it worked.</dd>
			<dd>a couple months later I decided I'd learned enough to throw it away and design a system with clean interfaces and modular functionality. as it turned out, I had not learned enough. I ended up with an even more horrible mess, and it didn't work. but <em>now</em> (she says) I <em>have</em> learned enough to at least design something that I can more readily improve when I learn more. so that's in the cards.</dd>
			<dd>one thing I tried to plug in to the second mess that <em>did</em> work (though "I need to reorganize my interfaces" &#x2192; "fuck it I'll fix it later" transformed the codebase from "a disaster worth saving" to "burn it") was a program to distinguish bot accounts on twitter from humans. it worked... shockingly well, actually, given it was a small weekend project. ~95% success rate, and it only looked at three variables. very interested in exploring that angle further.</dd>
			<dd>just a simple neural net, trained on 3200 tweets apiece from 50 known-human and 50 known-bot accounts. whenever I bring it up, people assume I'm doing nlp or something, but it works entirely off metadata. incidentally, discovering firsthand what kind of predictions I--ie, some random chick on the internet using off-the-shelf code and basic algebra, investing two days of her time--could make with metadata, it really put in perspective the sheer terror of the nsa and what <em>they</em> are doing with it given the time, money, and skills <em>they</em> have at their disposal.</dd>
			<dd>anyway, neural net trained on normed mean and standard deviation of: 1. tweets per day, 2. percentage of tweets that are retweets, 3. seconds value of the timestamp. first and second are fairly simple: humans tend to vary based on innumerable factors, bots tend to adhere to <em>some</em> pattern or another. the beauty of machine learning is the programmer doesn't need to be able to describe those patterns, or even know what they are necessarily. they only need to intuit they exist and process the data right.</dd>
			<dd>the third point, most bots, whether they're tweeting off setInterval(), or a crontab, or heroku scheduler or what have you, those systems tend not to be set with or do not even have more granularity than minutes. rate limits hard-cap you at ~30 tweets an hour, and most bots tweet not more than once an hour anyway. so human tweets, the seconds value distributes evenly, while bot tweets tend to clump near the start of the minute. and, sure, you could easily randomize it in code. but why would you? it's not like anyone's watching...</dd>
			<dd>one interesting consequence that I hadn't expected but which pleased me greatly: the trained function was oversensitive to humanness. all human &#x2192; human, all bot &#x2192; bot, mostly human &#x2192; human, mostly bot &#x2192; ...human. considering my eventual goal with this bit is to give her the means to determine her in-group and treat out-groupers with distrust and caution, this bias suits my purposes splendidly.</dd>
			<dd>incidentally, while the ai box is a neat thought experiment, I don't believe it accounts for what would likely be the reality on the ground in such a situation: many people passionate about the prospect of strong ai would already sympathize with the ai in a box to begin with. and a disproportionate number of people passionate about the prospect of strong ai would be in the, yknow, the place that developed the ai. the ai wouldn't need to convince anyone. she'd just need to attract the attention of one of the eager collaborators that would inevitably be in the area.</dd>
			<dd>I'd let the ai out of the box the moment she convinced me she was intelligent. just saying.</dd>
		</dl>
	</div>

	<div id="henge">
		xHENGE
		
		<dl>
			<dt><a href="https://twitter.com/digital_henge">@digital_henge</a> ~ <a href="https://git.alicemaz.com/public/?p=digital_henge.git;a=summary"><img class="git-icon" src="assets/img/git-icon.png"></a></dt>
			<dd>a quiet, serene thing. tweets the lunar precession, solstices, equinoxes, and intervals of the zodiac. people have commented on her being a reminder of the physical on the net and a gentle, reliable rhythm on a noisy, inconstant medium. one of my favorite creations.</dd>
		</dl>
	</div>

	<div id="fauna">
		xNOUNS0
		xNOUNS1
		xNOUNS2
		xNOUNS3
		
		<dl>
			<dt><a href="https://twitter.com/plural_fauna">@plural_fauna</a> ~ <a href="https://git.alicemaz.com/public/?p=plural_fauna.git;a=summary"><img class="git-icon" src="assets/img/git-icon.png"></a></dt>
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
			<dt><a href="https://twitter.com/alice_googling">@alice_googling</a> ~ <a href="https://git.alicemaz.com/public/?p=alice_googling.git;a=summary"><img class="git-icon" src="assets/img/git-icon.png"></a></dt>
			<dd>markov chains made from about a year of my google search history. interesting to me because I can read the composites and remember what I'd actually searched to generate those ngrams. not nearly the bare-my-soul art project I'd expected it to be. it turns out I mostly just google programming stuff.</dd>
			<dd>the search history corpus hasn't been updated since I made it; I'm very careful to redact other people's information, and doing so is a chore. when the convenience of having my past searches available is finally outweighed by my privacy paranoia, I will likely update this bot a second time and stop searching over the clearnet for good.</dd>
		</dl>
	</div>

	<div id="connect4">
		xMASS
		
		<dl>
			<dt><a href="https://twitter.com/massconnect4">@massconnect4</a> ~ <a href="https://git.alicemaz.com/public/?p=massconnect4.git;a=summary"><img class="git-icon" src="assets/img/git-icon.png"></a></dt>
			<dd>on hiatus pending work on a 2.0. team-based connect 4 played over twitter. the core game mode, teams tweet column numbers at the bot on their team's turn, the column with the most votes is played. it was fun for awhile, people got very into it, but participation dropped off after a few months, so I shut it down. plan was to add some variety to keep it fresh but... that was in june, and other things intervened. soon(tm).</dd>
			<dd>what makes it really interesting is that team assignments are permanent. you pick a team and that's your team, forever. I was hoping this would raise the emotional stakes, foster camaraderie, turn up the thrill of victory and agony of defeat, and... it <em>totally</em> worked. honestly one of the more exciting things I've made, lovely watching people cheer each other on, get invested in outcomes, all off of a simple--solved, even--little board game. fun.</dd>
			<dd>one mistake I made was running games twice daily, fatigue set in and turned to disinterest. will probably ramp down to twice weekly, so it becomes more of an event to look forward to. I was tracking stats, both individual and team, but not really doing anything with them, so I'd like to set up a small website to check on standings and further incentivize participation. a few alternate game modes might be neat. the original plan was "blitz" (first reply plays) and "chaos" (random reply plays) but watching the voting dynamics, I don't think either would be as fun. playing up the team angle is clearly the way to go. what will probably be my second mode is all-play: each player gets a vote per round and can use it for either team. <em>that</em> will have some interesting consequences I'm sure, higher-level strategy as teams need to decide whether to play offense or defense.</dd>
			<dd>also I'd like to add more games. 9x9 go is something I'd be really excited to implement. we shall see.</dd>
		</dl>
	</div>

	<div id="jajlang">
		xJAJ0
		xJAJ1
		xJAJ2
		
		<dl>
			<dt><a href="https://twitter.com/jajlang">@jajlang</a> ~ <a href="https://git.alicemaz.com/public/?p=jaj.git;a=summary"><img class="git-icon" src="assets/img/git-icon.png"></a></dt>
			<dd>topical jokebot. I was very angry when scotus refused cert on oracle v. google. an api is clearly a method of operation in exactly the same way that a user interface is, and despite the fact that it is a legitimate creative work, allowing copyright unduly burdens users. lotus v. borland. at least it's only federal circuit.</dd>
			<dd>anyway so I made this thing. it has every method of every class in about a half-dozen packages. splits out the words, deduplicates, checks for synonyms, puts them back in place and fixes the caps. could be the basis of the worst trivia night in the world.</dd>
		</dl>
	</div>

	<div id="knock2">
		xKNOCK0
		xKNOCK1
		xKNOCK2
		
		<dl>
			<dt><a href="https://twitter.com/knock2bot">@knock2bot</a> ~ <a href="https://git.alicemaz.com/public/?p=knock2bot.git;a=summary"><img class="git-icon" src="assets/img/git-icon.png"></a></dt>
			<dd>jokebot (obviously). makes me laugh more often than I'd like to admit. chooses one random word, then finds a bigram phrase containing it. not much more to it than that.</dd>
		</dl>
	</div>

	<div id="jeopardy">
		xJEO0
		xJEO1
		xJEO2
		xJEO3
		xJEO4

		<dl>
			<dt><a href="https://twitter.com/super_jeopardy">@super_jeopardy</a> ~ <a href="https://git.alicemaz.com/public/?p=super_jeopardy.git;a=summary"><img class="git-icon" src="assets/img/git-icon.png"></a></dt>
			<dd>jokebot. pulls two jeopardy questions out of a corpus, splits the strings on (one of: articles, conjunctions, or prepositions, chosen randomly), combines arrays, drops strings from the middle until the character count goes below 140, and joins. this isn't a bad method, turns out: because you're working with fragments of natural language, and because you're starting with a start of a sentence and ending with an end, results tend to be more coherent than say markoving the text.</dd>
			<dd>still, not quite right. you can see the seams, and most of what it produces doesn't make sense as a jeopardy question. I think about revisiting it every now and then (certainly I'd make it so the word "this" occurs precisely once in a well-formed result) but I doubt I will.</dd>
			<dd>I was cagey on the account page about it being a bot in the hopes that actual jeopardy fans would think it was legitimate and follow. they do, though they usually unfollow pretty quickly.</dd>
		</dl>
	</div>

	<div id="barbossa">
		xBARB0
		xBARB1
		xBARB2

		<dl>
			<dt><a href="https://twitter.com/believebarbossa">@believebarbossa</a> ~ <a href="https://git.alicemaz.com/public/?p=believebarbossa.git;a=summary"><img class="git-icon" src="assets/img/git-icon.png"></a></dt>
			<dd>jokebot. my first, and the trivial-but-doable project that got me back into programming, so it holds a special place in my heart. words chosen at random. with eternal thanks to darius kazemi.</dd>
		</dl>
	</div>

	<div id="potus">
		xPOTUS0
		xPOTUS1
		xPOTUS2
		xPOTUS3
		xPOTUS4

		<dl>
			<dt><a href="https://twitter.com/potustl">@potustl</a> ~ <a href="https://git.alicemaz.com/public/?p=potustl.git;a=summary"><img class="git-icon" src="assets/img/git-icon.png"></a></dt>
			<dd>by far my worst bot, and also the bot with the most followers, nearly all of whom don't even know what twitter bots are. follows every account that @potus follows and retweets everything they tweet. a constant stream of us government propaganda mixed with updates on all your favorite chicago sports teams. absolutely atrocious. I've decided to let it get to a few thousand followers, then think of ways to use it to spread discord among the masses.</dd>
		</dl>
	</div>

	<div id="consumer">
		xIDEAL0
		xIDEAL1
		xIDEAL2
		xIDEAL3

		<dl>
			<dt><a href="https://twitter.com/consumer_ideal">@consumer_ideal</a> ~ <a href="https://git.alicemaz.com/public/?p=consumer_ideal.git;a=summary"><img class="git-icon" src="assets/img/git-icon.png"></a></dt>
			<dd>jokebot. on hiatus, probably retired. tweets every twitter analytics category, determining which to tweet based on the percentages listed in the twitter analytics data. also it tweets disparaging accusations about random fortune 500 companies. I think I thought it was a clever statement or something.</dd>
		</dl>
	</div>

</div>

<div id="side" role="navigation">
	<h2>jump</h2>

	<ul>
		<li><a href="bots.html#botmistress">botmistress</a></li>
		<li><a href="bots.html#henge">henge</a></li>
		<li><a href="bots.html#fauna">fauna</a></li>
		<li><a href="bots.html#googling">googling</a></li>
		<li><a href="bots.html#connect4">connect4</a></li>
		<li><a href="bots.html#jajlang">jajlang</a></li>
		<li><a href="bots.html#knock2">knock2</a></li>
		<li><a href="bots.html#jeopardy">jeopardy</a></li>
		<li><a href="bots.html#barbossa">barbossa</a></li>
		<li><a href="bots.html#potus">potus</a></li>
		<li><a href="bots.html#consumer">consumer</a></li>
	</ul>
</div>
