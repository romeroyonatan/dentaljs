angular.module('dentaljs.patient_detail', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:id',
    templateUrl: '/assets/patient_detail/patient_detail.jade'
    controller: 'PatientDetailCtrl'
]

.controller 'PatientDetailCtrl', ["$scope", "$routeParams", "Person",
  "Accounting", ($scope, $routeParams, Person, Accounting) ->
    
    id = $routeParams.id
    getAccounting = ->
      $scope.accounting = Accounting.query person: id, ->
        $scope.total = 0
        $scope.total += a.amount for a in $scope.accounting

    $scope.patient = Person.get id: id
    getAccounting()

    $scope.new_account = ->
      accounting = new Accounting $scope.accounting
      accounting.person = id
      accounting.date = new Date
      accounting.$save()
      getAccounting()

    $scope.invalidate = (account) ->
      accounting = new Accounting
        person: id
        date: new Date
        description: "Invalidate #{account.description} from #{account.date}"
        amount: -1 * account.amount
      accounting.$save()
      getAccounting()

    $scope.payed = (account) ->
      accounting = new Accounting
        person: id
        date: new Date
        description: "Pay #{account.description} from #{account.date}"
        amount: -1 * account.amount
      accounting.$save()
      getAccounting()

]

