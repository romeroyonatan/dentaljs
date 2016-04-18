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
      {code: "A", description: "Enfermedad A", _id: 'a'},
      {code: "B", description: "Enfermedad B", _id: 'b'},
      {code: "C", description: "Enfermedad C", _id: 'c'},
      {code: "D", description: "Enfermedad D", _id: 'd'},
    ]

    $scope.fixes = [
      {code: "X", description: "Arreglo X", _id: 'x'},
      {code: "Y", description: "Arreglo Y", _id: 'y'},
      {code: "Z", description: "Arreglo Z", _id: 'z'},
    ]

    $scope.pieces = []
    $scope.description = ""

    # attach issue to teeth. This issue could be either a fix or a disease
    attachIssue = (id, sector, issue) ->
      # if piece exists
      if $scope.pieces[id]?
        piece = $scope.pieces[id]
      # create a new piece
      else
        piece = id: id, sectors: []
        $scope.pieces[id] = piece
      piece.sectors.push id: sector, issue: issue


    # when user clicks over a fix button, mark all selected sectors as fixed
    $scope.setFix = (fix) ->
      # get selected sectors
      selected = $ '.selected'
      # mark sectors as fixed
      selected.each (index, elem) ->
        id = $(elem).parents('.piece').attr('id')
        sector = $(elem).attr('id')
        attachIssue id, sector, fix._id
      # removed selected state
      selected.removeClass()
              .addClass 'sector fix'
              .attr 'title', fix.description
      # ok!
      return true

    # when user clicks over a disease button, mark all selected sectors as
    # diseased
    $scope.setDisease = (disease) ->
      # get selected sectors
      selected = $ '.selected'
      # mark sectors as disease
      selected.each (index, elem) ->
        id = $(elem).parents('.piece').attr('id')
        sector = $(elem).attr('id')
        attachIssue id, sector, disease._id
      # removed selected state
      selected.removeClass()
              .addClass 'sector disease'
              .attr 'title', disease.description
      # ok!
      return true

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
