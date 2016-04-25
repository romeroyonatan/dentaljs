describe 'dentaljs.patient_payments module', ->
  $scope = null
  $route = null
  $httpBackend = null
  controller = null

  beforeEach module 'dentaljs.services'
  beforeEach module 'dentaljs.patient_payments'

  beforeEach inject ($injector) ->
    # Get hold of a scope (i.e. the root scope)
    $scope = $injector.get '$rootScope'
    # The $controller service is used to create instances of controllers
    $controller = $injector.get '$controller'
    $route = $injector.get '$route'
    $httpBackend = $injector.get '$httpBackend'
    $httpBackend.whenGET('/persons').respond 200
    $httpBackend.whenGET('/accounting').respond 200
    $httpBackend.whenGET('/accounting/balance/undefined').respond 200
    $httpBackend.whenPOST('/accounting').respond 201
    # create new controller
    controller = $controller 'PatientPaymentsCtrl',
                             '$scope': $scope,
                             '$route':$route

  it 'it should add new account with assets amount', (done)->
    $scope.new(description: "Test", assets: 88.77).then ->
      expect($scope.accounting.length).toEqual 1
      expect($scope.balance).toEqual 88.77
      done()
    $httpBackend.flush()

  it 'it should add new account with debit amount', (done)->
    $scope.new(description: "Test", debit: 77).then ->
      expect($scope.accounting.length).toEqual 1
      expect($scope.balance).toEqual -77
      done()
    $httpBackend.flush()

  it 'it should add new account with assets amount', (done)->
    $scope.new(description: "Test", assets: 88.77).then ->
      expect($scope.accounting.length).toEqual 1
      expect($scope.balance).toEqual 88.77
      done()
    $httpBackend.flush()

  it 'it should add new account with assets and debit amount', (done)->
    $scope.new(description: "Test", assets: 50, debit: 100).then ->
      expect($scope.accounting.length).toEqual 1
      expect($scope.balance).toEqual -50
      done()
    $httpBackend.flush()

  it 'it should add multiple accounts with assets and debit amount', (done)->
    $scope.new(description: "Test1", assets: 150).then ->
      $scope.new(description: "Test2", debit: 250).then ->
        expect($scope.accounting.length).toEqual 2
        expect($scope.balance).toEqual -100
        expect($scope.accounting[0].description).toEqual "Test1"
        expect($scope.accounting[1].description).toEqual "Test2"
        done()
    $httpBackend.flush()

  it 'it should remove an existing account', (done)->
    spyOn($route, 'reload')
    # create mock account
    account =
      description: "Test"
      debit: 200
      _id: 'abcxyz'
    $httpBackend.expectDELETE('/accounting/abcxyz').respond 200
    # delete accounting
    $scope.delete(account).then ->
      # check if it deleted
      expect($route.reload).toHaveBeenCalled()
      done()
    $httpBackend.flush()

  it 'it should remove an existing account with another existing accounts',
  (done)->
    # create mock account
    spyOn($route, 'reload')
    $scope.accounting = [
      {description: "Test1", debit: 200},
      {description: "Test2", debit: 200},
      {description: "Test3", debit: 200},
    ]
    account =
      description: "Test"
      debit: 200
      _id: 'abcxyz'
    # delete accounting
    $httpBackend.expectDELETE('/accounting/abcxyz').respond 200
    $scope.delete(account).then ->
      # check if it deleted
      expect($route.reload).toHaveBeenCalled()
      done()
    $httpBackend.flush()

  it 'it should update a accounting with debit amount', (done)->
    $scope.new(description: "Test1", debit: 150).then ->
      spyOn($route, 'reload')
      $httpBackend.expectPUT('/accounting/abcxyz').respond 200
      $scope.update(description: "ABC", debit: 50, _id: 'abcxyz').then ->
        expect($route.reload).toHaveBeenCalled()
        done()
    $httpBackend.flush()

  it 'it should update a accounting with assets amount', (done)->
    $scope.new(description: "Test1", assets: 150).then ->
      spyOn($route, 'reload')
      $httpBackend.expectPUT('/accounting/abcxyz').respond 200
      $scope.update(description: "ABC", assets: 50, _id: 'abcxyz').then ->
        expect($route.reload).toHaveBeenCalled()
        done()
    $httpBackend.flush()

  it 'should add dependent accounting', (done)->
    # define main accounting
    father =
      description: "test1"
      debit: 200
      #_id: 'father'

    # define dependant account
    child =
      description: "test1"
      assets: 100
      #_id: 'child'
      parent: father

    # create accounting
    $scope.new(father).then ->
      $scope.new(child).then ->
        expect($scope.accounting.length).toEqual 2
        expect($scope.balance).toEqual -100
        done()
    $httpBackend.flush()
