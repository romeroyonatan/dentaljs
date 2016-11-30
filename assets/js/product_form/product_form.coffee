angular.module('dentaljs.product_form', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/products/new/',
    templateUrl: '/partials/product_form/product_form.html'
    controller: 'ProductFormCtrl'
  $routeProvider.when '/products/:id/edit',
    templateUrl: '/partials/product_form/product_form.html'
    controller: 'ProductFormCtrl'
]

.controller 'ProductFormCtrl', ["$scope", "$location", "$routeParams",
  "Product", ($scope, $location, $routeParams, Product) ->
    if $routeParams.id?
      $scope.product = Product.get id: $routeParams.id
    # Save button
    $scope.save = (product) ->
      product = new Product product
      if $routeParams.id?
        promise = product.$update()
      else
        promise = product.$save()
      promise.then -> toastr.success "Producto guardado con exito"
        .then -> $location.path "/products"
        .catch -> toastr.error "No se pudo guardar el producto"

    # Cancel button
    $scope.cancel = -> $location.path "/products"
]
