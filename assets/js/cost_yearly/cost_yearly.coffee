angular.module('dentaljs.cost_yearly', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/costos/:year',
    templateUrl: '/partials/cost_yearly/cost_yearly.html'
    controller: 'CostYearlyCtrl'
]

.controller 'CostYearlyCtrl', ["$scope", "$http", "$routeParams",
($scope, $http, $routeParams) ->
  # Almacena lo gastado por mes
  str_months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio'
                 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
  $scope.year = $routeParams.year
  $scope.months = []

  ###
  loadTotalMonth
  --------------------------------------------------------------------------
  Carga los totales gastados en cada mes
  ###
  loadTotalMonth = ->
    [1..12].forEach (month) ->
      $http.get("/costs/total/#{$routeParams.year}/#{month}").then (res) ->
        $scope.months[month - 1] =
          number: month
          name: str_months[month - 1]
          total: res.data.total

  ###
  getTotal
  --------------------------------------------------------------------------
  Obtiene el total de todos los meses
  ###
  $scope.getTotal = ->
    total = 0
    $scope.months.forEach (month)->
      total += month.total
    return total

  ###
  getAvg
  --------------------------------------------------------------------------
  Obtiene el promedio de todos los meses con gastos cargados al sistema
  ###
  $scope.getAvg = ->
    total = 0
    lenght = 0
    for month in $scope.months when month.total > 0
      total += month.total
      lenght++
    return if lenght > 1 then total / lenght else 0

  loadTotalMonth()
]
