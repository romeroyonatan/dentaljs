angular.module('dentaljs.patient_payments', ['ngRoute', 'ui.bootstrap'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/payments',
    templateUrl: '/partials/patient_payments/patient_payments.html'
    controller: 'PatientPaymentsCtrl'
]

.controller 'PatientPaymentsCtrl', [
  "$scope", "$routeParams", "$route","$uibModal", "Person", "Accounting",
  ($scope, $routeParams, $route, $uibModal, Person, Accounting) ->
    # initialize scope vars
    $scope.accounting = []
    $scope.balance = 0

    # get patient and its accounting
    $scope.patient = Person.get slug: $routeParams.slug, ->
      $scope.accounting = Accounting.query person: $scope.patient._id, ->
        $scope.balance += a.balance for a in $scope.accounting

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
      accounting.$save()
      add(accounting)
      toastr.success "Registro creado con éxito"
      return true

    # remove accounting
    $scope.delete = (account) -> account.$delete ->
      subtract(account)
      toastr.success "Registro eliminado con éxito"
      return true

    # edit existing accounting
    $scope.update = (account) ->
      account.person = $scope.patient._id
      resource = new Accounting account
      resource.$update()
      # hide modal
      $route.reload()
      toastr.success "Registro actualizado con éxito"
      return true

    # shows a modal with update's form
    $scope.showEdit = (account) ->
      $uibModal.open
        templateUrl: 'partials/patient_payments/modal_edit.html'
        controller: 'ModalUpdateCtrl',
        size: 'lg',
        resolve:
          account: account
      .result.then (account)-> $scope.update(account)
]

.controller 'ModalUpdateCtrl', ['$scope', '$uibModalInstance', 'account',
  ($scope, $uibModalInstance, account) ->
    $scope.account = account
    $scope.ok = -> $uibModalInstance.close $scope.account
    $scope.cancel = -> $uibModalInstance.dismiss 'cancel'
]
