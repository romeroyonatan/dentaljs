angular.module('dentaljs.odontogram_edit', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  # New URL
  $routeProvider.when '/patients/:slug/odontograms/new',
    templateUrl: '/partials/odontogram_edit/odontogram_edit.html'
    controller: 'OdontogramEditCtrl'
  # Edit URL
  $routeProvider.when '/patients/:slug/odontograms/:id/edit',
    templateUrl: '/partials/odontogram_edit/odontogram_edit.html'
    controller: 'OdontogramEditCtrl'
]

.controller 'OdontogramEditCtrl', [
  "$scope", "$routeParams", "$location", "Person", "Odontogram", "Issue"
  ($scope, $routeParams, $location, Person, Odontogram, Issue) ->
    # Get patient
    $scope.patient = Person.get slug: $routeParams.slug

    # Issues constants
    # -----------------
    # 1. Disease
    # 2. Fix
    DISEASE = 1
    FIX = 2

    # Get list of diseases
    $scope.diseases = Issue.query type: 1
    # Get list of fixes
    $scope.fixes =  Issue.query type: 2
    $scope.pieces = []
    # indicate if any sector is selected
    $scope.sector_selected = off


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

    # Get odontogram if I have its id
    if $routeParams.id?
      odontogram = Odontogram.get id: $routeParams.id, ->
        load odontogram

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
      console.assert issue.id?
      # if piece exists
      if $scope.pieces[issue.id]?
        piece = $scope.pieces[issue.id]
      # create a new piece
      else
        piece = id: issue.id, sectors: []
        $scope.pieces[issue.id] = piece

      # ### Sector's issues
      if issue.sector?
        piece.sectors[issue.sector] =
          id: issue.sector,
          issue: issue.issue if issue.issue?

      # ### Piece's issues
      else
        # reset issues
        piece.sectors = []
        delete piece.issue
        # set issue to piece
        piece.issue = "removed" if issue.removed
        piece.issue = "missed" if issue.missed
        piece.issue = "rotate-right" if issue.rotateRight
        piece.issue = "rotate-left" if issue.rotateLeft

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
      $scope.sector_selected = false

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
      $scope.sector_selected = false

    # when user clicks over a removed button, mark all teeths selected as
    # removed
    $scope.setRemoved = (id) ->
      # reset sectors
      # XXX findbyCssSelector
      $("##{id} .sector").removeClass().addClass('sector').attr('title', '')
      $("##{id} .missed,
         ##{id} .rotate-right,
         ##{id} .rotate-left").hide()
      # show/hide strikethough
      # XXX findbyCssSelector
      $("##{id} .removed").toggle()
      # mark teeth as removed
      $scope.attachIssue
        id: id
        removed: $("##{id} .removed").is(":visible")

    # setRotateRight
    # ------------------------------------------------------------------------
    # fires when when user clicks over rotate-right button.
    $scope.setRotateRight = (id) ->
      # reset sectors
      $("##{id} .sector").removeClass().addClass('sector').attr('title', '')
      $("##{id} .removed,
         ##{id} .missed,
         ##{id} .rotate-left").hide()
      $("##{id} .rotate-right").toggle()
      # mark teeth as rotated
      $scope.attachIssue
        id: id
        rotateRight: $("##{id} .rotate-right").is(":visible")

    # setRotateLeft
    # ------------------------------------------------------------------------
    # fires when when user clicks over rotate-left button.
    $scope.setRotateLeft = (id) ->
      # reset sectors
      $("##{id} .sector").removeClass().addClass('sector').attr('title', '')
      $("##{id} .removed,
         ##{id} .missed,
         ##{id} .rotate-right").hide()
      $("##{id} .rotate-left").toggle()
      # mark teeth as rotated
      $scope.attachIssue
        id: id
        rotateLeft: $("##{id} .rotate-left").is(":visible")

    # setMissed
    # ------------------------------------------------------------------------
    # fires when when user clicks over missed button.
    $scope.setMissed = (id) ->
      # reset sectors
      $("##{id} .sector").removeClass().addClass('sector').attr('title', '')
      $("##{id} .removed,
         ##{id} .rotate-right,
         ##{id} .rotate-left").hide()
      # mark teeth as missed
      $("##{id} .missed").toggle()
      $scope.attachIssue
        id: id
        missed: $("##{id} .missed").is(":visible")

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
      $scope.sector_selected = false

    # Build odontogram's object for send to server
    $scope.save = ->
      pieces = $scope.pieces.filter Boolean
      # get id of issue instead of the object
      for piece in pieces
        for sector in piece.sectors when sector?
          sector.issue = sector.issue._id if sector.issue?
      # make odontogram object
      odontogram = new Odontogram
        pieces: pieces
        comments: $scope.comments
        title: $scope.title
        person: $scope.patient._id
      if $routeParams.id?
        odontogram._id = $routeParams.id
        odontogram.$update().then ->
          toastr.success "Odontograma actualizado con éxito"
          $location.path "/patients/#{$scope.patient.slug}/odontograms"
      else
        odontogram.$save().then ->
          toastr.success "Odontograma creado con éxito"
          $location.path "/patients/#{$scope.patient.slug}/odontograms"

    # Bindings for teeth's sector click
    # XXX findbyCssSelector
    $(".sector")
      .on "click touchstart", (e) ->
        e.preventDefault()
        # XXX replace toogleClass
        $(@).toggleClass("selected")
        # enable or disables toolbar
        # XXX findbyCssSelector
        $scope.sector_selected = $(".selected").length > 0
        $scope.$apply()
      .on "touchmove", (e) ->
        e.preventDefault()
]
