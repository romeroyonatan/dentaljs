angular.module('dentaljs.patients', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients',
    templateUrl: '/partials/patient/all'
    controller: 'PatientListCtrl'
  
  $routeProvider.when '/patients/create',
    templateUrl: '/partials/patient/form'
    controller: 'PatientCreateCtrl'

  $routeProvider.when '/patients/:id/delete',
    templateUrl: '/partials/patient/delete'
    controller: 'PatientDeleteCtrl'

  $routeProvider.when '/patients/:id/update',
    templateUrl: '/partials/patient/form'
    controller: 'PatientUpdateCtrl'

  $routeProvider.when '/patients/:id',
    templateUrl: '/partials/patient/detail'
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
