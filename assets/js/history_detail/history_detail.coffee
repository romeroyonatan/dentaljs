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
    $scope.categories = {}

    # loadAnswers
    # ------------------------------------------------------------------------
    # get patient's answers
    loadAnswers = ->
      $http.get("/questions/"+ $scope.patient._id).then (res) ->
        $scope.answers = res.data
        $scope.answers.forEach setCategory
        console.log $scope.categories

    # setCategory
    # ------------------------------------------------------------------------
    # Separate answers by question's categories
    setCategory = (answer) ->
      category = answer.question.category
      if not $scope.categories[category]?
        $scope.categories[category] = answers: []
      $scope.categories[category].answers.push answer

    # get patient info
    $scope.patient = Person.get slug: $routeParams.slug, loadAnswers
]
