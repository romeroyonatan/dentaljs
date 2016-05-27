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
    # 1. Disease
    # 2. Fix
    DISEASE = 1
    FIX = 2

    # Array that holds teeths information
    $scope.pieces = []

    # Loading odontogram information
    # ================================
    # Loading colors in SVG based in odontogram information
    load = (odontogram) ->
      $scope.title = odontogram.title
      $scope.comments = odontogram.comments
      if odontogram.pieces?
        for piece in odontogram.pieces
          $scope.pieces[piece.id] = piece
          # Show piece's issues
          id = "##{piece.id} "
          switch piece.issue
            when "removed" then angular.element(id + ".removed").show()
            when "missed" then angular.element(id + ".missed").show()
            when "rotate-left" then angular.element(id + ".rotate-left").show()
            when "rotate-right" then angular.element(id+".rotate-right").show()
          # Show sectors with diseases or fixes
          for sector in piece.sectors when sector?
            elem = angular.element id + "##{sector.id}"
            elem.addClass 'disease' if sector.issue.type is DISEASE
            elem.addClass 'fix' if sector.issue.type is FIX

    # Get patient info
    $scope.patient = Person.get slug: $routeParams.slug, ->
      # Get odontogram
      $scope.odontogram = Odontogram.get id: $routeParams.id, ->
        # loading odontogram information
        load($scope.odontogram)
]
