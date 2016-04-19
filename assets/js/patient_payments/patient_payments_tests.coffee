describe 'dentaljs.patient_payments module', ->
  $scope = null
  controller = null

  beforeEach module 'dentaljs.services'
  beforeEach module 'dentaljs.patient_payments'

  beforeEach inject ($injector) ->
    # Get hold of a scope (i.e. the root scope)
    $scope = $injector.get '$rootScope'
    # The $controller service is used to create instances of controllers
    $controller = $injector.get '$controller'
    # create new controller
    controller = $controller 'PatientPaymentsCtrl', '$scope': $scope

  it 'it should add new account with debit amount', ->
    $scope.new description: "Test", debit: 77
    expect($scope.accounting.length).toEqual 1
    expect($scope.balance).toEqual -77

  it 'it should add new account with credit amount', ->
    $scope.new description: "Test", credit: 88.77
    expect($scope.accounting.length).toEqual 1
    expect($scope.balance).toEqual 88.77

  it 'it should add new account with credit and debit amount', ->
    $scope.new description: "Test", credit: 50, debit: 100
    expect($scope.accounting.length).toEqual 1
    expect($scope.balance).toEqual -50

  it 'it should add multiple accounts with credit and debit amount', ->
    $scope.new description: "Test1", credit: 150
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
