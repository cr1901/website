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
	

}]);

	
