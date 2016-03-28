angular.module('dentaljs.patient_delete', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:id/delete',
    templateUrl: '/partials/patient_delete.html'
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
