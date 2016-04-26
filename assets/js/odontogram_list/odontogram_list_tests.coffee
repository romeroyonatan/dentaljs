describe 'dentaljs.odontogram_list module', ->
  $scope = null
  $httpBackend = null
  controller = null

  beforeEach module 'dentaljs.services'
  beforeEach module 'dentaljs.odontogram_list'

  beforeEach inject ($injector) ->
    # Get hold of a scope (i.e. the root scope)
    $scope = $injector.get '$rootScope'
    # The $controller service is used to create instances of controllers
    $controller = $injector.get '$controller'
    $httpBackend = $injector.get '$httpBackend'
    # create new controller
    controller = $controller 'OdontogramLiatCtrl',
                             '$scope': $scope,
