angular.module('dentaljs.patient_update', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:id/update',
    templateUrl: '/partials/patient_update.html'
    controller: 'PatientUpdateCtrl'
]

.controller 'PatientUpdateCtrl', ["$scope", "Person", "$location",
  "$routeParams", ($scope, Person, $location, $routeParams) ->
    $scope.patient = Person.get id: $routeParams.id, ->

    # Save button
      $scope.save = () ->
        $scope.patient.$update ->
          $location.path "/patients/#{$scope.patient._id}"

    # Cancel button
    $scope.cancel = () ->
      $location.path "/patients"
]
