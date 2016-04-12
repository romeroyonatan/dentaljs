angular.module('dentaljs.patient_treatment', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/treatment',
    templateUrl: '/partials/patient_treatment/patient_treatment.html'
    controller: 'PatientTreatmentCtrl'
]

.controller 'PatientTreatmentCtrl', [
  "$scope", "$routeParams", "Person", "Accounting",
  ($scope, $routeParams, Person, Accounting) ->
    $scope.patient = Person.get slug: $routeParams.slug
]
