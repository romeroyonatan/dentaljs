angular.module('dentaljs.product_form', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/products/new/',
    templateUrl: '/partials/product_form/product_form.html'
    controller: 'ProductFormCtrl'
]

.controller 'ProductFormCtrl', ["$scope", "$location",
  ($scope, $location) ->
    # Save button
    $scope.save = (product) ->
      console.log product

    # Cancel button
    $scope.cancel = () ->
]
