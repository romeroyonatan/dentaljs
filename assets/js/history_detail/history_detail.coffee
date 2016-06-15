angular.module('dentaljs.history_detail', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/history',
    templateUrl: '/partials/history_detail/history_detail.html'
    controller: 'HistoryDetailCtrl'
]

.controller 'HistoryDetailCtrl', [
  "$scope", "$routeParams", "$location", "$q", "$http", "Person"
  ($scope, $routeParams, $location, $q, $http, Person) ->
    $scope.answers = []
    # get patient info
    $scope.patient = Person.get slug: $routeParams.slug, ->
      # get patient's answers
      $http.get("/questions/"+ $scope.patient._id).then (res) ->
        $scope.answers = res.data
]
