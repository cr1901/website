angular.module("app").controller("favctrl", ["$scope", "$sce", function ($scope, $sce) {

	var Tweet = function(id, txt) {
		this.id = id;
		this.txt = txt;
		this.faved = false;
		this.img = "img/fav.png?"+new Date().getTime();
	};

	Tweet.prototype = {
		imgcheck: function(hover) {
			$scope.$apply(this.img = (this.faved ?"img/faved.png" :
									  (hover ? "img/fav-hover.png" : "img/fav.png"))+"?"+new Date().getTime());
		}
	};

	$scope.tweets = [
		new Tweet("614789739380670464","There is no more expressive tool of communication in the world than the fav. One single bit of information, but it can mean so many things"),
		new Tweet("614790948170637312","Fav: &quot;I like this&quot;<br/>Fav: &quot;I see this&quot;<br/>Fav: &quot;I feel a general type of good will toward you&quot;<br/>Fav: &quot;I'm not sure what to say, but I'm here&quot;"),
		new Tweet("614791905298259968","Fav: &quot;I'm exiting this conversation and want to leave on an up note&quot;<br/>Fav: &quot;Not only does yr abusive tweet not hurt, I revel in your scorn&quot;"),
		new Tweet("614793729094889472","when a person favs a tweet of yours that had been retweeted, then several that were not, then follows you"),
		new Tweet("614793982548250625","when a person favs one of yr tweets from over a year ago then has no further interaction with you"),
		new Tweet("614794197019836416","the difference between a retweet and a fav-retweet combo"),
		new Tweet("614794303135727616","when a man you don't know favs every one of yr selfies going back months"),
		new Tweet("614794483390128128","when a person who does not follow you favs a tweet that contains their name"),
		new Tweet("614794737556553728","when you fav something and immediately reply explaining what part of the tweet the fav is meant to apply to"),
		new Tweet("614795192697257984","when you're flirting with a cutie you really like and you both fav all of each others' tweets"),
		new Tweet("614795346590351363","when you're flirting with a cutie you really like and only one of you is faving the other's tweets"),
		new Tweet("614795612849074176","the self-fav"),
		new Tweet("614795995176693760","when you're flirting with a cutie and a mutual friend favs yr tweets<br/>when you're flirting with a cutie and a total stranger favs yr tweets"),
		new Tweet("614796631364517889","when you fav something but then realize you shouldn't have and can't decide whether it's worse to unfav or let it stand"),
		new Tweet("614797268395425793","when you fav someone subtweeting you<br/>when you fav someone subtweeting you, knowing they hoped you would see it"),
		new Tweet("614797554446954496","when you fav someone talking shit about a mutual, hoping that they see it"),
		new Tweet("614799693940432896","when you tweet a ton about favs knowing full well that the surest way to get favs is to tweet about favs<br/>(◡ ‿ ◡ ✿)")
	];

	$scope.finalTweet = new Tweet("614799904561610753","@alicemazzy harvesting them.. to fuel your mysterious fav engine..");

	twttr.events.bind("favorite", function(event) {
		var favtweet = _.find($scope.tweets.concat($scope.finalTweet), function(tweet) {
			return tweet.id == event.data.tweet_id;
		});

		favtweet && (favtweet.faved = true) && favtweet.imgcheck();
	});

}]);
