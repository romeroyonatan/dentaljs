angular.module('dentaljs.odontogram_edit', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/odontograms/edit',
    templateUrl:
      '/partials/odontogram_edit/odontogram_edit.html'
    controller: 'OdontogramEditCtrl'
]

.controller 'OdontogramEditCtrl', [
  "$scope", "$routeParams", ($scope, $routeParams) ->
    $scope.diseases = [
      {code: "A", description: "Enfermedad A"},
      {code: "B", description: "Enfermedad B"},
      {code: "C", description: "Enfermedad C"},
      {code: "D", description: "Enfermedad D"},
    ]

    $scope.fixes = [
      {code: "X", description: "Arreglo X"},
      {code: "Y", description: "Arreglo Y"},
      {code: "Z", description: "Arreglo Z"},
    ]

    $scope.pieces = []
    $scope.description = ""

    # build pieces array
    for quadrant in [1..4]
      for piece in [1..8]
        id = quadrant * 10 + piece
        $scope.pieces[id] =
          id: id
          sector: [0..4]

    # when user clicks over a fix button, mark all selected sectors as fixed
    $scope.setFix = (fix) ->
      # get selected sectors
      selected = $ '.selected'
      # mark sectors as fixed
      selected.each (index, elem) ->
        piece = $(elem).parents('.piece').attr('id')
        sector = $(elem).attr('id')
        $scope.pieces[piece].sector[sector] = fix.code
        console.log $scope.pieces[piece]
      # removed selected state
      selected.removeClass()
              .addClass 'sector fix'
              .attr 'title', fix.description
      # ok!
      return true

    # when user clicks over a disease button, mark all selected sectors as
    # diseased
    $scope.setDisease = (disease) ->
      $(".selected").removeClass()
                    .addClass 'sector disease'
                    .attr 'title', disease.description
      true

    # when user clicks over a removed button, mark all teeths selected as
    # removed
    $scope.setRemoved = ->
      $('.selected').nextAll('.removed').toggle()
      $('.selected').removeClass('selected')
      true

    # when user clicks over a clean button, clean selected sectors to default
    # value. If teeth is marked as removed, the mark will be clean
    $scope.clean = ->
      $('.selected').nextAll('.removed').hide()
      $(".selected").removeClass()
                    .addClass('sector')
                    .attr('title', '')
      true

    # Build odontogram's object for send to server
    $scope.save = ->
      odontogram =
        pieces: $scope.pieces.filter Boolean
        description: $scope.description
      console.log odontogram


    # Bindings for teeth's sector click
    $(".sector").on "click touchstart", (e) ->
      e.preventDefault()
      $(@).toggleClass("selected")
]
