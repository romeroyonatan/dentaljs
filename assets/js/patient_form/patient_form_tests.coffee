describe 'dentaljs.patient_form module', ->
  $httpBackend = null
  $rootScope = null
  createController = null

  beforeEach module 'dentaljs.services'
  beforeEach module 'dentaljs.patient_form'

  beforeEach inject ($injector) ->
    # Set up the mock http service responses
    $httpBackend = $injector.get '$httpBackend'
    # Get hold of a scope (i.e. the root scope)
    $rootScope = $injector.get '$rootScope'
    # The $controller service is used to create instances of controllers
    $controller = $injector.get '$controller'


    createController = ->
      return $controller 'PatientFormCtrl', '$scope': $rootScope

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()


  describe 'patient_form controller', ->
    it 'should send a born date', inject ($controller) ->
      $httpBackend.expectPOST('/persons',
        person: born: date: new Date('1990-12-19')
      ).respond(201, '')
      controller = createController()
      $rootScope.save person: born: date: '1990-12-19'
      $httpBackend.flush()
