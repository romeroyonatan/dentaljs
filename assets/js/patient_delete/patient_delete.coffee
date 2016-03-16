angular.module('dentaljs.patient_delete', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:id/delete',
    templateUrl: '/assets/patient_delete/patient_delete.jade'
    controller: 'PatientDeleteCtrl'
]

.controller 'PatientDeleteCtrl', ["$scope", "Person", "$location",
  "$routeParams", ($scope, Person, $location, $routeParams) ->
    $scope.patient = Person.get id: $routeParams.id, ->
      # delete button
      $scope.delete = ->
        $scope.patient.$delete ->
          $location.path "/patients"

    # cancel button
    $scope.cancel = ->
      $location.path "/patients"
]
