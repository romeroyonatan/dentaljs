angular.module('dentaljs.odontogram_edit', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/odontograms/edit',
    templateUrl:
      '/partials/odontogram_edit/odontogram_edit.html'
    controller: 'OdontogramEditCtrl'
]

.controller 'OdontogramEditCtrl', [
  "$scope", "$routeParams", "Person", ($scope, $routeParams, Person) ->
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

    $scope.patient = Person.get slug: $routeParams.slug

    $scope.pieces = []
    $scope.description = ""
    $scope.selected = false

    # Attach issue to teeth.
    # =======================
    # This issue could be a fix, a disease or a removed
    # teeth
    #
    # Parameters:
    # ------------------
    # * issue.id: the teeth's identification
    # * issue.sector: the sector affected. it could be null if teeth is removed
    # * issue.code: if sector is fix or disease, it is the code of them
    # * issue.removed: if teeth was removed
    attachIssue = (issue) ->
      # if piece exists
      if $scope.pieces[issue.id]?
        piece = $scope.pieces[issue.id]
      # create a new piece
      else
        piece = id: issue.id, sectors: []
        $scope.pieces[issue.id] = piece
      piece.sectors[issue.sector] =
        id: issue.sector,
        issue: issue.code if issue.code?
      if issue.removed?
        piece.sectors = []
        # toggle remove attr
        piece.removed = piece.removed isnt true

    # when user clicks over a fix button, mark all selected sectors as fixed
    $scope.setFix = (fix) ->
      # get selected sectors
      selected = $ '.selected'
      # mark sectors as fixed
      selected.each (index, elem) ->
        id = $(elem).parents('.piece').attr('id')
        sector = $(elem).attr('id')
        attachIssue id: id, sector: sector, code: fix._id
      # removed selected state
      selected.removeClass()
              .addClass 'sector fix'
              .attr 'title', fix.description
      # disable toolbar
      $scope.selected = false

    # when user clicks over a disease button, mark all selected sectors as
    # diseased
    $scope.setDisease = (disease) ->
      # get selected sectors
      selected = $ '.selected'
      # mark sectors as disease
      selected.each (index, elem) ->
        id = $(elem).parents('.piece').attr('id')
        sector = $(elem).attr('id')
        attachIssue id: id, sector: sector, code: disease._id
      # removed selected state
      selected.removeClass()
              .addClass 'sector disease'
              .attr 'title', disease.description
      # disable toolbar
      $scope.selected = false

    # when user clicks over a removed button, mark all teeths selected as
    # removed
    $scope.setRemoved = (id) ->
      # reset sectors
      $("##{id} .sector").removeClass().addClass('sector').attr('title', '')
      # show/hide strikethough
      $("##{id} .removed").toggle()
      # mark teeth as removed
      attachIssue id: id, removed: true

    # when user clicks over a clean button, clean selected sectors to default
    # value. If teeth is marked as removed, the mark will be clean
    $scope.clean = ->
      # get selected sectors
      selected = $ '.selected'
      # reset sector marks
      selected.each (index, elem) ->
        id = $(elem).parents('.piece').attr('id')
        sector = $(elem).attr('id')
        delete $scope.pieces[id]
      # reset widget appearance
      selected.removeClass()
              .addClass('sector')
              .attr('title', '')
      # disable toolbar
      $scope.selected = false

    # Build odontogram's object for send to server
    $scope.save = ->
      odontogram =
        pieces: $scope.pieces.filter Boolean
        comments: $scope.comments
        title: $scope.title
        person: $scope.patient._id
      console.log odontogram

    # Bindings for teeth's sector click
    $(".sector")
      .on "click touchstart", (e) ->
        e.preventDefault()
        $(@).toggleClass("selected")
        # enable or disables toolbar
        $scope.selected = $(".selected").length > 0
        $scope.$apply()
      .on "touchmove", (e) ->
        e.preventDefault()
]
