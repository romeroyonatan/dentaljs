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
      # get only defined prices
      prices = prices.filter (price) -> price?
      $http
        .post("/costs/direct/prices", prices)
        .then -> toastr.success "Los cambios se han guardado correctamente"
        .then -> $location.path "/products"
        .catch -> toastr.error "Ha habido un error al guardar los cambios"

    # Save product button
    $scope.saveProduct = (product) ->
      product = new Product product
      # agrego a la lista para dar sensacion de velocidad
      $scope.products.push(product)
      product.$save()
        # muestra mensaje de exito
        .then -> toastr.success "Se ha creado un producto nuevo"
        # limpia formulario
        .then -> $scope.product = {}
        # en caso de no poder guardarlo, lo elimina de la lista
        .catch -> $scope.products.pop()

    # Cancel button
    $scope.cancel = () ->
]
