angular.module('dentaljs.cost_monthly_form', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/costos/mes/:month/:year',
    templateUrl: '/partials/cost_monthly_form/cost_monthly_form.html'
    controller: 'CostMonthlyFormCtrl'
]

.controller 'CostMonthlyFormCtrl', ["$scope", "$location", "$routeParams",
($scope, $location, $routeParams) ->
  year = $routeParams.year
  month = $routeParams.month
  console.log "mes %d, año %d", month, year
  $scope.month = moment("#{year}#{month}01").format('MMMM YYYY')
  $scope.categorias = {
    "Servicios": [
      {
        name: "Electricidad",
      },
      {
        name: "Gas",
      },
      {
        name: "Agua",
      },
      {
        name: "Internet",
      },
    ],
    "Impuestos": [
      {
        name: "Impuesto municipal",
      },
      {
        name: "Impuesto provincial",
      },
      {
        name: "Impuesto nacional",
      },
    ],
    "Asesoramiento": [
      {
        name: "Asesoramiento legal",
      },
      {
        name: "Asesoramiento contable",
      },
    ],
  }
]
