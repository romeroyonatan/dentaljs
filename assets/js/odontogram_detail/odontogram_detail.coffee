angular.module('dentaljs.odontogram_detail', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/odontograms/:id',
    templateUrl: '/partials/odontogram_detail/odontogram_detail.html'
    controller: 'OdontogramDetailCtrl'
]

.controller 'OdontogramDetailCtrl', [
  "$scope", "$routeParams", "$route", "Person", "Odontogram",
  ($scope, $routeParams, $route, Person, Odontogram) ->

    # # Issues constants
    DISEASE = 1
    FIX = 2

    $scope.pieces = []
    # # Loading odontogram information
    # Loading colors in SVG based in odontogram information
    load = (odontogram) ->
      if odontogram.pieces?
        for piece in odontogram.pieces
          $scope.pieces[piece.id] = piece

          # Show strikethough if teeth is missed
          if piece.removed
            strikethough = angular.element "##{piece.id} .removed"
            strikethough.show()

          # Show sectors with diseases or fixes
          for sector in piece.sectors when sector?
            elem = angular.element "##{piece.id} ##{sector.id}"
            elem.addClass 'disease' if sector.issue.type is DISEASE
            elem.addClass 'fix' if sector.issue.type is FIX

    $scope.patient = Person.get slug: $routeParams.slug, ->
      $scope.odontogram = Odontogram.get id: $routeParams.id, ->
        load($scope.odontogram)
]
