angular.module('dentaljs.patient_detail', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug',
    templateUrl: '/partials/patient_detail.html'
    controller: 'PatientDetailCtrl'
]

.controller 'PatientDetailCtrl', [
  "$scope", "$routeParams", "Person", "Accounting",
  ($scope, $routeParams, Person, Accounting) ->
    $scope.patient = Person.get slug: $routeParams.slug
]
