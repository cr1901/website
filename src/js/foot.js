angular.module("app").controller("footctrl", ["$scope", "$location", "$anchorScroll", function ($scope, $location, $anchorScroll) {

	$scope.load = function(itemname) {
		$location.url("/"+itemname);
		$scope.refocus();
		$anchorScroll();
	};

	$scope.refocus = function() {
		_.find(document.getElementsByClassName("head"), function(val) {
			return window.getComputedStyle(val).display != "none";
		}).focus();
	};

}]);

	
