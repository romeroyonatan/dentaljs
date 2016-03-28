angular.module('dentaljs.patient_create', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/create',
    templateUrl: '/partials/patient_create.html'
    controller: 'PatientCreateCtrl'
]

.controller 'PatientCreateCtrl', ["$scope", "Person", "$location",
  ($scope, Person, $location) ->
    
    # Save button
    $scope.save = () ->
      person = new Person $scope.patient
      person.$save ->
        $location.path "/patients/#{person.slug}"

    # Cancel button
    $scope.cancel = () ->
      $location.path "/patients"
]
