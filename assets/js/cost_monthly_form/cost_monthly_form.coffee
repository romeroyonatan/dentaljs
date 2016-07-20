angular.module('dentaljs.cost_monthly_form', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/costos/mes/:month/:year',
    templateUrl: '/partials/cost_monthly_form/cost_monthly_form.html'
    controller: 'CostMonthlyFormCtrl'
]

.controller 'CostMonthlyFormCtrl', ["$scope", "$http", "$routeParams",
($scope, $http, $routeParams) ->
  $scope.month = moment("#{$routeParams.year}#{$routeParams.month}01")
  $scope.categories = []
  _categories = {}

  ###
  # loadCategories
  # --------------------------------------------------------------------------
  # Carga categories de gastos
  ###
  loadCategories = ->
    $http.get('/costs/categories/month').then (res) ->
      $scope.categories = res.data
      # armo hash table de categories para acelerar busquedas
      $scope.categories.forEach (category) ->
        category.items.forEach (item) ->
          _categories[item._id] = item

  ###
  # loadData
  # --------------------------------------------------------------------------
  # Carga valores guardados anteriormente
  ###
  loadData = ->
    $http.get("/costs/month/#{$routeParams.year}/#{$routeParams.month}")
    .then (res) ->
      res.data.forEach (cost) ->
        cat = _categories[cost.category]
        if cat?
          cat.ref = cost._id
          cat.price = cost.price
  ###

  # getTotal
  # --------------------------------------------------------------------------
  # Obtiene la sumatoria de gastos del mes.
  ###
  $scope.getTotal = ->
    total = 0
    for id of _categories
      if _categories[id].price? and /^\d+$/.test _categories[id].price
        total += parseFloat(_categories[id].price)
    return total

  ###
  # getDayly
  # --------------------------------------------------------------------------
  # Obtiene el promedio de gasto por día
  ###
  $scope.getDayly = ->
    return $scope.getTotal() / 30

  ###
  # getHourly
  # --------------------------------------------------------------------------
  # Obtiene el promedio de gasto por hora
  ###
  $scope.getHourly = ->
    return $scope.getDayly() / 24

  ###
  # save
  # --------------------------------------------------------------------------
  # Guarda los cambios en la base de datos
  ###
  $scope.save = ->
    items = []
    for id of _categories when _categories[id].price?
      obj =
        category: _categories[id]._id
        date: $scope.month.toDate()
        price: _categories[id].price
      if _categories[id].ref?
        obj._id = _categories[id].ref
      items.push obj
    $http.post '/costs/month', items

  loadCategories().then loadData()
]
