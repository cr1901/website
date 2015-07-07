angular.module("app").controller("botctrl", ["$scope", function ($scope) {

	$scope.moon = function() {
		var arr = [
			"\uD83C\uDF11",
			"\uD83C\uDF12",
			"\uD83C\uDF13",
			"\uD83C\uDF14",
			"\uD83C\uDF15",
			"\uD83C\uDF16",
			"\uD83C\uDF17",
			"\uD83C\uDF18"
		];

		return twemoji.parse(arr[(function() {
			var d = new Date();
			var year = d.getFullYear();
			var month = d.getMonth();
			var day = d.getDate();

			var r = year % 100;
			r %= 19;
			if (r>9){ r -= 19;}
			r = ((r * 11) % 30) + parseInt(month) + parseInt(day);
			if (month<3){r += 2;}
			r -= ((year<2000) ? 4 : 8.3);
			r = Math.floor(r+0.5)%30;
			r = (r < 0) ? r+30 : r;
			//my additions, convert 0-29 to 0-8 then change 8 to 0
			r = Math.floor(r/3.625);
			r = r & 7;
			return r;
		})()]);
	};

	twttr.widgets.load(document.getElementsByClassName("bottweets")[0]);
}]);
