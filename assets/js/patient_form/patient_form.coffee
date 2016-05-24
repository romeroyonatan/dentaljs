angular.module('dentaljs.patient_form',
['ngRoute', 'ui.bootstrap', 'checklist-model'])

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
    # Available tag
    $scope.tags = ['Ortodoncia', 'Tratamiento', 'Ocasional']

    # Load person
    if $routeParams.slug
      $scope.patient = Person.get slug: $routeParams.slug, ->
        $scope.patient.civil_status = "" + $scope.patient.civil_status

    # Save button
    $scope.save = (patient) ->
      if patient.civil_status?
        patient.civil_status = parseInt patient.civil_status
      person = new Person patient
      if not $routeParams.slug
        person.$save -> $location.path "/patients/#{person.slug}"
      else
        person.slug = $routeParams.slug
        person.$update -> $location.path "/patients/#{person.slug}"

    # Cancel button
    $scope.cancel = () ->
      if $routeParams.slug
        $location.path "/patients/#{$routeParams.slug}"
      else
        $location.path "/patients"
]
