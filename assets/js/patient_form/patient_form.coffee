angular.module('dentaljs.patient_form', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/create',
    templateUrl: '/partials/patient_form/patient_form.html'
    controller: 'PatientFormCtrl'
  $routeProvider.when '/patients/:slug/update',
    templateUrl: '/partials/patient_form/patient_form.html'
    controller: 'PatientFormCtrl'
]

.controller 'PatientFormCtrl', ["$scope", "Person", "$location",
  "$routeParams", ($scope, Person, $location, $routeParams) ->

    # Load person
    if $routeParams.slug
      $scope.patient = Person.get slug: $routeParams.slug

    # Save button
    $scope.save = (patient) ->
      person = new Person patient
      if not $routeParams.slug
        person.$save ->
          $location.path "/patients/#{person.slug}"
      else
        person.slug = $routeParams.slug
        person.$update ->
          $location.path "/patients/#{person.slug}"

    # Cancel button
    $scope.cancel = () ->
      $location.path "/patients"
]
