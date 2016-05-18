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
    $httpBackend.whenGET("/folders/foo").respond 200, _id: 'abcxyz'
    $httpBackend.whenGET "/partials/patient_gallery/patient_gallery.html"
                .respond 200, _id: 'abcxyz'
    $controller 'PatientGalleryCtrl',
                '$routeParams': slug: 'foo'
                '$scope': $scope
    $scope.patient = slug: 'foo'

  it 'should upload a photo', ->
    $httpBackend.expectPOST("/images/foo").respond 201
    $scope.uploadPhoto [{}]
    $httpBackend.flush()

  it 'should upload a photo into folder', ->
    $httpBackend.expectPOST("/images/foo/biz").respond 201
    $scope.folder = _id: 'biz', name: 'foldername'
    $scope.uploadPhoto [{}]
    $httpBackend.flush()

  it 'should remove a photo', ->
    $httpBackend.expectDELETE("/images/bar").respond 201
    $scope.removePhoto _id: 'bar'
    $httpBackend.flush()

  it 'should create a folder', ->
    $httpBackend.expectPOST("/folders/foo").respond 201
    $scope.createFolder 'foldername'
    $httpBackend.flush()

  it 'should remove a folder', ->
    $httpBackend.expectDELETE("/folders/biz").respond 204
    $scope.removeFolder _id: 'biz'
    $httpBackend.flush()

  it 'should rename a folder', ->
    $httpBackend.expectPUT("/folders/biz", (data)-> /fulano/.test data)
                .respond 200
    $scope.renameFolder _id: 'biz', 'fulano'
    $httpBackend.flush()

  it 'should move image to folder', ->
    $httpBackend.expectPUT("/images/id_image", (data) -> /id_folder/.test data)
                .respond 201
    $scope.move {_id: 'id_image'}, {_id: 'id_folder'}
    $httpBackend.flush()

  it 'should show image of determinated folder', ->
    $httpBackend.expectGET("/folders/foo/test").respond 201
    $httpBackend.expectGET("/images/foo/test").respond 201
    $controller 'PatientGalleryCtrl',
                '$routeParams': slug: 'foo', folder: 'test'
                '$scope': $scope
    $scope.patient = slug: 'foo'
    $httpBackend.flush()
