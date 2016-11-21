angular.module('dentaljs.product_price_form', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/products/price/',
    templateUrl: '/partials/product_price_form/product_price_form.html'
    controller: 'ProductPriceFormCtrl'
]

.controller 'ProductPriceFormCtrl', ["$scope", "$location", "$http", "Product",
  ($scope, $location, $http, Product) ->
    $scope.products = Product.query()
    # Save button
    $scope.save = () ->
      prices =  for product in $scope.products
        if product.price?.price
          product: product._id,
          price: product.price.price,
          source: product.price.source
      prices = prices.filter (elem) -> elem
      $http.post("/costs/direct/prices", prices)
      .then ->
        toastr.success "Los cambios se han guardado correctamente"
      .catch ->
        toastr.error "Ha habido un error al guardar los cambios"

    # Cancel button
    $scope.cancel = () ->
]
