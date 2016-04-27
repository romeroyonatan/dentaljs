angular.module('dentaljs.patient_payments',
  ['ngRoute', 'ui.bootstrap', 'angular-confirm'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/payments',
    templateUrl: '/partials/patient_payments/patient_payments.html'
    controller: 'PatientPaymentsCtrl'
]

.controller 'PatientPaymentsCtrl', ["$scope", "$routeParams", "$route",
  "$http", "$uibModal", "Person", "Accounting",
  ($scope, $routeParams, $route, $http, $uibModal, Person, Accounting) ->
    # initialize scope vars
    $scope.accounting = []
    $scope.balance = 0

    # get patient and its accounting
    $scope.patient = Person.get slug: $routeParams.slug, ->
      $scope.accounting = Accounting.query person: $scope.patient._id, ->
        $http.get("/accounting/balance/" + $scope.patient._id).then (res) ->
          $scope.balance = res.data.balance

    # add new accounting to list and add mounts to balance
    add = (account)->
      $scope.accounting.push account
      # modify balance
      $scope.balance -= account.debit if account.debit?
      $scope.balance += account.assets if account.assets?
      # clean scope's account
      $scope.account = {}

    # remove accounting from list and subtract from balance
    subtract = (account)->
      $scope.accounting = (
        a for a in $scope.accounting when a._id isnt account._id
      )
      $scope.balance += account.debit if account.debit?
      $scope.balance -= account.assets if account.assets?

    # create new account
    $scope.new = (account) ->
      account.person = $scope.patient._id
      accounting = new Accounting account
      accounting.$save().then ->
        add(accounting)
        toastr.success "Registro creado con éxito"

    # remove accounting
    $scope.delete = (account) ->
      account = new Accounting account if account not instanceof Accounting
      account.$delete().then ->
        $route.reload()
        toastr.success "Registro eliminado con éxito"

    # edit existing accounting
    $scope.update = (account) ->
      account.person = $scope.patient._id
      resource = new Accounting account
      resource.$update().then ->
        # Reload page
        $route.reload()
        toastr.success "Registro actualizado con éxito"

    # shows a modal with update's form
    $scope.showEdit = (account) ->
      $uibModal.open
        templateUrl: 'partials/patient_payments/modal_edit.html'
        controller: 'ModalUpdateCtrl',
        resolve:
          account: account
      .result.then (account) -> $scope.update account

    # shows a modal to create a dependant account
    $scope.showDependant = (account) ->
      $uibModal.open
        templateUrl: 'partials/patient_payments/modal_dependant.html'
        controller: 'ModalDependantCtrl'
        resolve: parent: account
      .result.then (account) ->
        $scope.new account
        $route.reload()
]

.controller 'ModalUpdateCtrl', ['$scope', '$uibModalInstance', 'account',
  ($scope, $uibModalInstance, account) ->
    $scope.account = account
    $scope.ok = -> $uibModalInstance.close $scope.account
    $scope.cancel = -> $uibModalInstance.dismiss 'cancel'
]

.controller 'ModalDependantCtrl', ['$scope', '$uibModalInstance', 'parent',
  ($scope, $uibModalInstance, parent) ->
    $scope.account =
      parent: parent
    $scope.ok = -> $uibModalInstance.close $scope.account
    $scope.cancel = -> $uibModalInstance.dismiss 'cancel'
]
