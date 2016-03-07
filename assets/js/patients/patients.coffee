
angular.module('myApp.patients', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients',
    templateUrl: '/partials/patient/all'
    controller: 'PatientListCtrl'
  
  $routeProvider.when '/patients/create',
    templateUrl: '/partials/patient/create'
    controller: 'PatientCreateCtrl'

  $routeProvider.when '/patients/delete/:id',
    templateUrl: 'partials/patient/delete'
    controller: 'PatientDeleteCtrl'

  $routeProvider.when '/patients/:id',
    templateUrl: 'partials/patient/detail'
    controller: 'PatientDetailCtrl'
]

.controller 'PatientListCtrl', ["$scope", ($scope) ->
  $scope.patients = patients
]

.controller 'PatientDetailCtrl', ["$scope", "$routeParams", "$location",
  ($scope, $routeParams, $location) ->
      $scope.patient = p for p in patients when p.id is $routeParams.id
]

.controller 'PatientCreateCtrl', ["$scope", "$location", ($scope, $location) ->
  $scope.create = (patient) ->
    patient.id = "#{patients.length + 1}"
    patients.push patient
    $location.path "/"
  $scope.cancel = () ->
    $location.path "/"
]

.controller 'PatientDeleteCtrl', ["$scope", "$location",
  ($scope, $location) ->
    $scope.delete = (patient) ->
      patients = p for p in patients when p.id isnt patient.id
      $location.path "/"
]

# ############################################################################
# Esto sera reemplazado por una API RESTful
patients = [
  {
    id: "asd123f2d3123922"
    name: "Fernando Paredes"
    phone: "12345678"
  },
  {
    id: "1a902339bc3d3eff87f"
    name: "Jimena Perez"
    phone: "11223344"
  },
  {
    id: "abcdef1234567890"
    name: "Susana Horia"
    phone: "22334455"
  },
]
# ############################################################################
