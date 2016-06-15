describe 'dentaljs.history_detail module', ->
  $scope = null
  $httpBackend = null
  controller = null

  beforeEach module 'dentaljs.services'
  beforeEach module 'dentaljs.history_detail'

  beforeEach inject ($injector) ->
    # Get hold of a scope (i.e. the root scope)
    $scope = $injector.get '$rootScope'
    # The $controller service is used to create instances of controllers
    $controller = $injector.get '$controller'
    $httpBackend = $injector.get '$httpBackend'
    $httpBackend.whenGET('/persons').respond 200
    # create new controller
    controller = $controller 'HistoryDetailCtrl',
                             '$scope': $scope,
