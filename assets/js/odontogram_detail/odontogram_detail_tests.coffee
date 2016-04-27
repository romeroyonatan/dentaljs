describe 'dentaljs.odontogram_detail module', ->
  $scope = null
  $httpBackend = null
  $controller = null

  beforeEach module 'dentaljs.services'
  beforeEach module 'dentaljs.odontogram_detail'

  beforeEach inject ($injector) ->
    # Get hold of a scope (i.e. the root scope)
    $scope = $injector.get '$rootScope'
    # The $controller service is used to create instances of controllers
    $controller = $injector.get '$controller'
    $httpBackend = $injector.get '$httpBackend'

  it 'should retrieve a odontogram', ->
    $httpBackend.expectGET("/persons/abcxyz").respond 200, _id: 'abcxyz'
    $httpBackend.expectGET("/odontograms/123abc").respond 200, _id: '123abc'
    # Get detail
    controller = $controller 'OdontogramDetailCtrl',
                             '$scope': $scope,
                             '$routeParams': slug: 'abcxyz', id: '123abc'

    $httpBackend.flush()
    expect($scope.odontogram?).toBe true
    expect($scope.odontogram._id).toEqual '123abc'
    expect($scope.patient._id).toEqual 'abcxyz'
