angular.module("app",["ngRoute", "ngSanitize"])
.factory("Cats", function() {
	return [{
		name: "twine",
		open: false,
		items: [
			{
				name: "feminine aspect",
				url: "fem.html"
			},
			{
				name: "affect engine",
				url: "affect.html"
			},
			{
				name: "colorado red",
				url: "colorado.html"
			},
			{
				name: "breakfast on a wagon with your partner",
				url: "breakfast.html"
			},
			{
				name: "core/dump",
				url: "coredump.html"
			}
		]
	},
	{
		name: "bots",
		open: false,
		items: [
			{
				name: "digital henge",
				url: "henge.html"
			},
			{
				name: "jokebots",
				url: "jokebots.html"
			}
		]
	},
	{
		name: "etc",
		open: false,
		items: [
			{
				name: "mysterious fav engine",
				url: "fav.html",
				ctrl: "fav.js"
			}
		]
	}]
})
.config(function($locationProvider) {
	$locationProvider.html5Mode(true).hashPrefix("!");
})
.config(function($routeProvider) {
	$routeProvider
	.when("/", {
		templateUrl: "main.html",
		//	controller: "contentCtrl"
	})
	.when("/twine/:twineName", {
		templateUrl: function(args) { return "/twine/"+args.twineName+".html"; },
		//	controller: "ctrl"
	})
	.when("/bots/:botName", {
		templateUrl: function(args) { return "/bots/"+args.botName+".html"; },
		controller: "botctrl"
	})
	.when("/about", {
		templateUrl: "about.html"
	})
	.when("/etc/:etcName", {
		templateUrl: function(args) { return "/etc/"+args.etcName+".html"; },
		controller: "favctrl" //fix this later lol
	})
	.otherwise({
		redirectTo: "/"
	})
});
