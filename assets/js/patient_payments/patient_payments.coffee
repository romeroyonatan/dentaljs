angular.module('dentaljs.patient_payments', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/payments',
    templateUrl: '/partials/patient_payments/patient_payments.html'
    controller: 'PatientPaymentsCtrl'
]

.controller 'PatientPaymentsCtrl', [
  "$scope", "$routeParams", "$route", "Person", "Accounting",
  ($scope, $routeParams, $route, Person, Accounting) ->
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
      if account.debit?
        $scope.balance -= account.debit
      if account.credit?
        $scope.balance += account.credit
      # clean scope's account
      $scope.account = {}

    # remove accounting from list and subtract from balance
    subtract = (account)->
      $scope.accounting = (
        a for a in $scope.accounting when a._id isnt account._id
      )
      if account.debit?
        $scope.balance += account.debit
      if account.credit?
        $scope.balance -= account.credit

    # create new account
    $scope.new = (account) ->
      accounting = new Accounting account
      accounting.person = $scope.patient._id
      accounting.assets = 0 if not account.assets?
      accounting.debit = 0 if not account.debit?
      accounting.$save()
      add(accounting)

    # edit existing accounting
    $scope.update = (account) ->
      accounting = new Accounting account
      accounting.person = $scope.patient._id
      accounting.assets = 0 if not account.assets?
      accounting.debit = 0 if not account.debit?
      accounting.$update()
      reload()

    # remove accounting
    $scope.delete = (account) -> account.$delete -> subtract(account)
]
