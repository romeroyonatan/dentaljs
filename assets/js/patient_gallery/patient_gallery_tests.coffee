describe 'dentaljs.patient_gallery module', ->
  $scope = null
  $httpBackend = null
  $controller = null

  beforeEach module 'dentaljs.services'
  beforeEach module 'dentaljs.patient_gallery'

  beforeEach inject ($injector) ->
    # Get hold of a scope (i.e. the root scope)
    $scope = $injector.get '$rootScope'
    # The $controller service is used to create instances of controllers
    $controller = $injector.get '$controller'
    $httpBackend = $injector.get '$httpBackend'

    $httpBackend.whenGET("/persons/foo").respond 200, _id: 'abcxyz'
    $httpBackend.whenGET("/images/foo").respond 200, _id: 'abcxyz'
    controller = $controller 'PatientGalleryCtrl',
                             '$routeParams': slug: 'foo'
                             '$scope': $scope
    $scope.patient = slug: 'foo'

  it 'should upload a photo', ->
    $httpBackend.expectPOST("/images/foo").respond 201
    $scope.uploadPhoto {}
    $httpBackend.flush()

  xit 'should upload a photo into folder', ->
    $httpBackend.expectPOST("/images/foo", (data) -> /folder=biz/.test data)
                .respond 201
    $scope.folder = _id: 'biz', name: 'foldername'
    $scope.uploadPhoto {}
    $httpBackend.flush()

  xit 'should remove a photo', ->
    $httpBackend.expectDELETE("/images/bar").respond 201
    $scope.removePhoto _id: 'bar'
    $httpBackend.flush()

  xit 'should create a folder', ->
    $httpBackend.expectPOST("/folders/foo").respond 201
    $scope.createFolder 'foldername'
    $httpBackend.flush()

  xit 'should remove a folder', ->
    $httpBackend.expectDELETE("/folders/foo/biz").respond 201
    $scope.removeFolder _id: 'biz'
    $httpBackend.flush()

  xit 'should move image to folder', ->
    $httpBackend.expectPUT("/images/foo", (data) -> /folder=biz/.test data)
                .respond 201
    $scope.move [_id: 'bar'], 'biz'
    $httpBackend.flush()

  xit 'should show image of determinated folder', ->
    $httpBackend.expectGET("/folder/foo/foldername").respond 201
    $scope.folder = _id: 'biz', name: 'foldername'
    $httpBackend.flush()
