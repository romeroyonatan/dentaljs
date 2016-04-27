describe 'dentaljs.odontogram_list module', ->
  $scope = null
  $httpBackend = null
  $controller = null
  Odontogram = null

  beforeEach module 'dentaljs.services'
  beforeEach module 'dentaljs.odontogram_list'

  beforeEach inject ($injector) ->
    # Get hold of a scope (i.e. the root scope)
    $scope = $injector.get '$rootScope'
    # The $controller service is used to create instances of controllers
    $controller = $injector.get '$controller'
    $httpBackend = $injector.get '$httpBackend'
    Odontogram = $injector.get 'Odontogram'
    $httpBackend.whenGET("/persons/abcxyz").respond 200, _id: '12345'

  it 'should show a list of odontograms', ->
    $httpBackend.expectGET("/odontograms?person=12345").respond 200
    # get odontogram's list
    controller = $controller 'OdontogramListCtrl',
                             '$scope': $scope,
                             '$routeParams': slug: 'abcxyz'
    $httpBackend.flush()

  it 'should delete an odontogram', ->
    $httpBackend.whenGET("/odontograms?person=12345").respond 200
    $httpBackend.expectDELETE("/odontograms/abc123").respond 204
    controller = $controller 'OdontogramListCtrl',
                             '$scope': $scope,
                             '$routeParams': slug: 'abcxyz'
    # call delete
    $scope.remove new Odontogram
      _id: 'abc123'
      person: '12345'
    $httpBackend.flush()
