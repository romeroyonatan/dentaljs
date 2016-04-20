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
    # create new controller
    controller = $controller 'PatientPaymentsCtrl',
                             '$scope': $scope,
                             '$route':$route

  it 'it should add new account with debit amount', ->
    $scope.new description: "Test", debit: 77
    expect($scope.accounting.length).toEqual 1
    expect($scope.balance).toEqual -77

  it 'it should add new account with assets amount', ->
    $scope.new description: "Test", assets: 88.77
    expect($scope.accounting.length).toEqual 1
    expect($scope.balance).toEqual 88.77

  it 'it should add new account with assets and debit amount', ->
    $scope.new description: "Test", assets: 50, debit: 100
    expect($scope.accounting.length).toEqual 1
    expect($scope.balance).toEqual -50

  it 'it should add multiple accounts with assets and debit amount', ->
    $scope.new description: "Test1", assets: 150
    $scope.new description: "Test2", debit: 250
    expect($scope.accounting.length).toEqual 2
    expect($scope.balance).toEqual -100
    expect($scope.accounting[0].description).toEqual "Test1"
    expect($scope.accounting[1].description).toEqual "Test2"

  it 'it should remove an existing account', ->
    # create mock account
    account =
      description: "Test"
      debit: 200
      _id: 'abc123'
      # mock $delete method
      $delete: (cb) -> cb?()
    # add account to accounting
    $scope.new account
    # delete accounting
    $scope.delete account
    # check if it deleted
    expect($scope.accounting.length).toEqual 0
    expect($scope.balance).toEqual 0

  it 'it should remove an existing account with another existing accounts', ->
    # create mock account
    account =
      description: "Test"
      debit: 200
      _id: 'abc123'
      # mock $delete method
      $delete: (cb) -> cb?()
    # add accounts
    $scope.new account
    $scope.new description: "Test2", debit: 200
    # delete accounting
    $scope.delete account
    # check if it deleted
    expect($scope.accounting.length).toEqual 1
    expect($scope.balance).toEqual -200

  it 'it should update a accounting with debit amount', ->
    $httpBackend.expectPOST('/accounting/abcxyz').respond 201
    $scope.new description: "Test1", debit: 150, _id: 'abcxyz'
    spyOn($route, 'reload')
    $httpBackend.expectPUT('/accounting/abcxyz').respond 200
    $scope.update description: "ABC", debit: 50, _id: 'abcxyz'
    expect($route.reload).toHaveBeenCalled()
    $httpBackend.flush()

  it 'it should update a accounting with assets amount', ->
    $httpBackend.expectPOST('/accounting/abcxyz').respond 201
    $scope.new description: "Test1", assets: 150, _id: 'abcxyz'
    spyOn($route, 'reload')
    $httpBackend.expectPUT('/accounting/abcxyz').respond 200
    $scope.update description: "ABC", assets: 50, _id: 'abcxyz'
    expect($route.reload).toHaveBeenCalled()
    $httpBackend.flush()

  it 'should add dependent accounting', ->
    # define main accounting
    father =
      description: "test1"
      debit: 200
      _id: 'father'

    # define dependant account
    child =
      description: "test1"
      assets: 100
      _id: 'child'
      parent: father

    # create accounting
    $scope.new father
    $scope.new child

    expect($scope.accounting.length).toEqual 2
    expect($scope.balance).toEqual -100
