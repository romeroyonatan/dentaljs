angular.module('dentaljs.patient_list', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients',
    templateUrl: '/partials/patient_list/patient_list.html'
    controller: 'PatientListCtrl'
]

.controller 'PatientListCtrl', ["$scope", "Person", ($scope, Person) ->
  # Tag which disable filter by tags
  ALL = "Todos"

  # Patient list
  $scope.patients = Person.query()
  # List of available tags
  $scope.tags = [ALL, 'Ortodoncia', 'Rehabilitación protética',
                 'Odontología general']
  # Current selected tag
  $scope.activeTag = ALL

  # selectTag
  # -------------------------------------------------------------------------
  # Mark tag as selected tag
  $scope.selectTag = (tag) -> $scope.activeTag = tag

  # filterByTags
  # -------------------------------------------------------------------------
  # Filter patient by selected tag
  $scope.filterByTags = (patient) ->
    if $scope.activeTag and $scope.activeTag isnt ALL
      return $scope.activeTag in patient.tags
    else
      return yes
]
