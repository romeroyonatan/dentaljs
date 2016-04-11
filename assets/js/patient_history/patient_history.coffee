angular.module('dentaljs.patient_history', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/history',
    templateUrl: '/partials/patient_history.html'
    controller: 'PatientHistoryCtrl'
]

.controller 'PatientHistoryCtrl', [
  "$scope", "$routeParams", "Person",
  ($scope, $routeParams, Person) ->
    $scope.patient = Person.get slug: $routeParams.slug
]
