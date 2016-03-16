angular.module('dentaljs.patient_create', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/create',
    templateUrl: '/assets/patient_create/patient_create.jade'
    controller: 'PatientCreateCtrl'
]

.controller 'PatientCreateCtrl', ["$scope", "Person", "$location",
  ($scope, Person, $location) ->
    
    # Save button
    $scope.save = () ->
      person = new Person $scope.patient
      person.$save ->
        $location.path "/patients"

    # Cancel button
    $scope.cancel = () ->
      $location.path "/patients"
]
