angular.module("app").controller("navctrl", ["$scope", "$location", "$anchorScroll", "Cats", function ($scope, $location, $anchorScroll, Cats) {

	$scope.cats = Cats;			

	$scope.expand = function(cat) {
		cat.open ? cat.open = false : (function(cat) {
			_.each($scope.cats, function(cat) {
				cat.open = false;
			});
			cat.open = true;
		})(cat);
	};
	
	$scope.load = function(catname, item) {
		$location.url("/"+catname+"/"+item.url.match(/[a-zA-Z0-9-_]*/));
		$scope.refocus();
		$anchorScroll();
	};

	$scope.refocus = function() {
		_.find(document.getElementsByClassName("head"), function(val) {
			return window.getComputedStyle(val).display != "none";
		}).focus();
	};

}]);

	
