angular.module('dentaljs.odontogram_edit', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/odontograms/edit',
    templateUrl:
      '/partials/odontogram_edit/odontogram_edit.html'
    controller: 'OdontogramEditCtrl'
]

.controller 'OdontogramEditCtrl', [
  "$scope", "$routeParams", "Person", "Odontogram", "Issue"
  ($scope, $routeParams, Person, Odontogram, Issue) ->
    $scope.diseases = Issue.query type: 1
    $scope.fixes =  Issue.query type: 2

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
    # * issue.issue: the fix or disease
    # * issue.removed: if teeth was removed
    $scope.attachIssue = (issue) ->
      # if piece exists
      if $scope.pieces[issue.id]?
        piece = $scope.pieces[issue.id]
      # create a new piece
      else
        piece = id: issue.id, sectors: []
        $scope.pieces[issue.id] = piece
      piece.sectors[issue.sector] =
        id: issue.sector,
        issue: issue.issue if issue.issue?
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
        # XXX Replace parents
        id = $(elem).closest('.piece').attr('id')
        # XXX Replace attr
        sector = $(elem).attr('id')
        $scope.attachIssue id: id, sector: sector, issue: fix
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
      selected = angular.element '.selected'
      # mark sectors as disease
      selected.each (index, elem) ->
        # XXX replace closest
        id = $(elem).closest('.piece').attr('id')
        # XXX replace attr
        sector = $(elem).attr('id')
        $scope.attachIssue id: id, sector: sector, issue: disease
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
      # XXX findbyCssSelector
      $("##{id} .sector").removeClass().addClass('sector').attr('title', '')
      # show/hide strikethough
      # XXX findbyCssSelector
      $("##{id} .removed").toggle()
      # mark teeth as removed
      $scope.attachIssue id: id, removed: true

    # when user clicks over a clean button, clean selected sectors to default
    # value. If teeth is marked as removed, the mark will be clean
    $scope.clean = ->
      # get selected sectors
      # XXX findbyCssSelector
      selected = $ '.selected'
      # reset sector marks
      selected.each (index, elem) ->
        # XXX replace closest
        id = $(elem).closest('.piece').attr('id')
        # XXX replace attr
        sector = $(elem).attr('id')
        delete $scope.pieces[id].sectors[sector]
      # reset widget appearance
      selected.removeClass()
              .addClass('sector')
              .attr('title', '')
      # disable toolbar
      $scope.selected = false

    # Build odontogram's object for send to server
    $scope.save = ->
      patient = Person.get slug: $routeParams.slug
      pieces = $scope.pieces.filter Boolean
      for piece in pieces
        for sector in piece.sectors when sector?
          sector.issue = sector.issue._id if sector.issue?
      odontogram = new Odontogram
        pieces: pieces
        comments: $scope.comments
        title: $scope.title
        person: patient._id
      odontogram.$save().then ->
        toastr.success "Odontograma creado con éxito"

    # Bindings for teeth's sector click
    # XXX findbyCssSelector
    $(".sector")
      .on "click touchstart", (e) ->
        e.preventDefault()
        # XXX replace toogleClass
        $(@).toggleClass("selected")
        # enable or disables toolbar
        # XXX findbyCssSelector
        $scope.selected = $(".selected").length > 0
        $scope.$apply()
      .on "touchmove", (e) ->
        e.preventDefault()
]
