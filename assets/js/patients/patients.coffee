angular.module('dentaljs.patients', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients',
    templateUrl: '/assets/patients/all.jade'
    controller: 'PatientListCtrl'
  
  $routeProvider.when '/patients/create',
    templateUrl: '/assets/patients/form.jade'
    controller: 'PatientCreateCtrl'

  $routeProvider.when '/patients/:id/delete',
    templateUrl: '/assets/patients/delete.jade'
    controller: 'PatientDeleteCtrl'

  $routeProvider.when '/patients/:id/update',
    templateUrl: '/assets/patients/form.jade'
    controller: 'PatientUpdateCtrl'

  $routeProvider.when '/patients/:id',
    templateUrl: '/assets/patients/detail.jade'
    controller: 'PatientDetailCtrl'
]

.controller 'PatientListCtrl', ["$scope", "Person", ($scope, Person) ->
  $scope.patients = Person.query()
]

.controller 'PatientDetailCtrl', ["$scope", "$routeParams", "Person",
  ($scope, $routeParams, Person) ->
    $scope.patient = Person.get id: $routeParams.id
]

.controller 'PatientCreateCtrl', ["$scope", "Person", "$location",
  ($scope, Person, $location) ->
    $scope.save = () ->
      person = new Person $scope.patient
      person.$save ->
        $location.path "/patients"
    $scope.cancel = () ->
      $location.path "/patients"
]

.controller 'PatientDeleteCtrl', ["$scope", "Person", "$location",
  "$routeParams", ($scope, Person, $location, $routeParams) ->
    $scope.patient = Person.get id: $routeParams.id, ->
      $scope.delete = ->
        $scope.patient.$delete ->
          $location.path "/patients"
    $scope.cancel = ->
      $location.path "/patients"
]

.controller 'PatientUpdateCtrl', ["$scope", "Person", "$location",
  "$routeParams", ($scope, Person, $location, $routeParams) ->
    $scope.patient = Person.get id: $routeParams.id
    $scope.save = () ->
      $scope.patient.$update ->
        $location.path "/patients"
    $scope.cancel = () ->
      $location.path "/patients"
]
