angular.module('dentaljs.patient_list', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients',
    templateUrl: '/partials/patient_list.html'
    controller: 'PatientListCtrl'
]

.controller 'PatientListCtrl', ["$scope", "Person", ($scope, Person) ->
  $scope.patients = Person.query()
]
