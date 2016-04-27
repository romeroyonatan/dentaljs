describe 'dentaljs.odontogram_edit module', ->
  $scope = null
  $httpBackend = null
  controller = null

  beforeEach module 'dentaljs.services'
  beforeEach module 'dentaljs.odontogram_edit'

  beforeEach inject ($injector) ->
    # Get hold of a scope (i.e. the root scope)
    $scope = $injector.get '$rootScope'
    # The $controller service is used to create instances of controllers
    $controller = $injector.get '$controller'
    $httpBackend = $injector.get '$httpBackend'
    $httpBackend.whenGET("/odontograms/issues?type=1").respond 200, [_id:'a']
    $httpBackend.whenGET("/odontograms/issues?type=2").respond 200, [_id:'x']
    # create new controller
    controller = $controller 'OdontogramEditCtrl',
                             '$scope': $scope,

  describe "Attach Issue's fix", ->

    issue =
      _id: 'x'
      code: 'X'
      description: 'Arreglo X'

    it 'should send a fix', ->
      $httpBackend.expectPOST "/odontograms",
        title: "Test"
        comments: "Test odontogram"
        pieces: [
          {id: 11, sectors: [id: 0, issue: issue._id]},
        ]
      .respond 201
      $httpBackend.whenGET("/persons").respond 200, {_id:'abc123'}
      $scope.title = "Test"
      $scope.comments = "Test odontogram"
      $scope.attachIssue
        id: 11
        sector: 0
        issue: issue
      $scope.save()
      $httpBackend.flush()
