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
  loaded = [
    {
      _id: 200
      category: 7
      price: 200
    }
    {
      _id: 201
      category: 1
      price: 500
    }
  ]
  $scope.categorias = {
    "Servicios": [
      {
        _id: 1,
        name: "Electricidad",
      },
      {
        _id: 2,
        name: "Gas",
      },
      {
        _id: 3,
        name: "Agua",
      },
      {
        _id: 4,
        name: "Internet",
      },
    ],
    "Impuestos": [
      {
        _id: 5,
        name: "Impuesto municipal",
      },
      {
        _id: 6,
        name: "Impuesto provincial",
      },
      {
        _id: 7,
        name: "Impuesto nacional",
      },
    ],
    "Asesoramiento": [
      {
        _id: 8,
        name: "Asesoramiento legal",
      },
      {
        _id: 9,
        name: "Asesoramiento contable",
      },
    ],
  }

  # armo hash table de categorias para acelerar busquedas
  _categorias = {}
  for i of $scope.categorias
    for item in $scope.categorias[i]
      _categorias[item._id] = item

  # Carga valores guardados anteriormente
  loaded.forEach (cost) ->
    cat = _categorias[cost.category]
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
    for id of _categorias
      total += parseFloat(_categorias[id].price) if _categorias[id].price?
    return total

  ###
  # save
  # --------------------------------------------------------------------------
  # Guarda los cambios en la base de datos
  ###
  $scope.save = ->
    items = []
    for id of _categorias when _categorias[id].price?
      obj =
        category: _categorias[id]._id
        date: new Date()
        price: _categorias[id].price
      obj._id = _categorias[id].ref if _categorias[id].ref?
      items.push obj
    console.log items
]
