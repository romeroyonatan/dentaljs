angular.module('dentaljs.direct_cost_report', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/products/',
    templateUrl: '/partials/direct_cost_report/direct_cost_report.html'
    controller: 'DirectCostReport'
]

.controller 'DirectCostReport', ["$scope", "$http", ($scope, $http) ->
  $scope.products = []
  $http.get('/costs/direct')
    .then (response) ->
      $scope.products = response.data
    .catch -> toastr.error "Hubo un error al traer los datos"
]
