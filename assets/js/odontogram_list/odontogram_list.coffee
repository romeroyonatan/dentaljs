angular.module('dentaljs.odontogram_list', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/odontograms',
    templateUrl:
      '/partials/odontogram_list/odontogram_list.html'
    controller: 'OdontogramListCtrl'
]

.controller 'OdontogramListCtrl', [
  "$scope", "$routeParams", "$route", "Person", "Odontogram",
  ($scope, $routeParams, $route, Person, Odontogram) ->
    $scope.patient = Person.get slug: $routeParams.slug, ->
      $scope.odontograms = Odontogram.query person: $scope.patient._id

    $scope.remove = (odontogram) ->
      odontogram.$delete().then ->
        toastr.success "Odontograma eliminado"
        $route.reload()
]
