angular.module('dentaljs.patient_detail', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:id',
    templateUrl: '/assets/patient_detail/patient_detail.jade'
    controller: 'PatientDetailCtrl'
]

.controller 'PatientDetailCtrl', ["$scope", "$routeParams", "Person",
  ($scope, $routeParams, Person) ->
    $scope.patient = Person.get id: $routeParams.id
]
