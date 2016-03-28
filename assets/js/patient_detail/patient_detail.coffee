angular.module('dentaljs.patient_detail', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug',
    templateUrl: '/partials/patient_detail.html'
    controller: 'PatientDetailCtrl'
]

.controller 'PatientDetailCtrl', [
  "$scope", "$routeParams", "Person", "Accounting",
  ($scope, $routeParams, Person, Accounting) ->
    
    getAccounting = ->
      $scope.accounting = Accounting.query person: $scope.patient._id, ->
        $scope.total = 0
        $scope.total += a.amount for a in $scope.accounting

    $scope.patient = Person.get slug: $routeParams.slug, ->
        getAccounting()

    $scope.new_account = ->
      accounting = new Accounting $scope.accounting
      accounting.person = $scope.patient._id
      accounting.date = new Date
      accounting.$save()
      getAccounting()

    $scope.invalidate = (account) ->
      accounting = new Accounting
        person: $scope.patient._id
        date: new Date
        description: "Invalida #{account.description} de #{account.date}"
        amount: -account.amount
        invalid: account
      accounting.$save()
      getAccounting()

    $scope.payed = (account) ->
      day = moment(account.date).format('L')
      accounting = new Accounting
        person: $scope.patient._id
        date: new Date
        description: "Paga #{account.description} de #{day}"
        amount: -account.amount
        pay: account
      accounting.$save()
      getAccounting()
]
