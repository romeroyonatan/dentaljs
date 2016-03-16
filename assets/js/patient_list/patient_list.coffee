angular.module('dentaljs.patient_list', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients',
    templateUrl: '/assets/patient_list/patient_list.jade'
    controller: 'PatientListCtrl'
]

.controller 'PatientListCtrl', ["$scope", "Person", ($scope, Person) ->
  $scope.patients = Person.query()
]
