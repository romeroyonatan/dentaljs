angular.module('dentaljs.product_detail', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/products/:id',
    templateUrl: '/partials/product_detail/product_detail.html'
    controller: 'ProductDetailCtrl'
]

.controller 'ProductDetailCtrl', ["$scope", "$location", "$routeParams",
"Product", ($scope, $location, $routeParams, Product) ->
    $scope.product = Product.get(id: $routeParams.id)

    $scope.delete = ->
      $scope.product.$delete()
        .then -> toastr.success "El producto se ha eliminado con exito"
        .then -> $location.path "/products"
]
