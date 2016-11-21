describe 'dentaljs.product_price_form module', ->
  $httpBackend = null
  $rootScope = null
  createController = null

  beforeEach module 'dentaljs.services'
  beforeEach module 'dentaljs.product_price_form'

  beforeEach inject ($injector) ->
    # Set up the mock http service responses
    $httpBackend = $injector.get '$httpBackend'
    # Get hold of a scope (i.e. the root scope)
    $rootScope = $injector.get '$rootScope'
    # The $controller service is used to create instances of controllers
    $controller = $injector.get '$controller'


    createController = ->
      return $controller 'ProductPriceFormCtrl', '$scope': $rootScope

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
