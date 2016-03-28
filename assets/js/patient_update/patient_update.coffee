angular.module('dentaljs.patient_update', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/update',
    templateUrl: '/partials/patient_update.html'
    controller: 'PatientUpdateCtrl'
]

.controller 'PatientUpdateCtrl', ["$scope", "Person", "$location",
  "$routeParams", ($scope, Person, $location, $routeParams) ->
    $scope.patient = Person.get slug: $routeParams.slug

    # Save button
    $scope.save = (patient) ->
      console.log patient
      patient.$update ->
        $location.path "/patients/" + patient.slug

    # Cancel button
    $scope.cancel = () ->
      $location.path "/patients"
]
