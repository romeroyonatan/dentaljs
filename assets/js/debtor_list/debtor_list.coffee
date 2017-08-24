angular.module('dentaljs.debtor_list', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/debtors',
    templateUrl: '/partials/debtor_list/debtor_list.html'
    controller: 'DebtorListCtrl'
]

.controller 'DebtorListCtrl', ["$scope", "$http", "Person",
($scope, $http, Person) ->
  $scope.debtors = []
  # Debtors list
  $http.get("/accounting/debtors/").then (res) ->
     $scope.debtors = res.data
]
