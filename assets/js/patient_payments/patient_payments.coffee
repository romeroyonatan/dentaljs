angular.module('dentaljs.patient_payments', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/payments',
    templateUrl: '/partials/patient_payments/patient_payments.html'
    controller: 'PatientPaymentsCtrl'
]

.controller 'PatientPaymentsCtrl', [
  "$scope", "$routeParams", "Person", "Accounting",
  ($scope, $routeParams, Person, Accounting) ->
    
    getAccounting = ->
      $scope.accounting = Accounting.query person: $scope.patient._id, ->
        $scope.balance = 0
        $scope.balance += a.balance for a in $scope.accounting

    $scope.patient = Person.get slug: $routeParams.slug, -> getAccounting()

    $scope.new_account = ->
      accounting = new Accounting $scope.account
      accounting.person = $scope.patient._id
      accounting.assets = 0 if not $scope.account.assets?
      accounting.debit = 0 if not $scope.account.debit?
      accounting.$save()
      $scope.account = new Accounting
      getAccounting()

    $scope.delete = (account) -> account.$delete -> getAccounting()
]
