angular.module('dentaljs.laboratory_workers', ['ngRoute', 'angular-confirm'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/laboratorios',
    templateUrl: '/partials/laboratory_workers/laboratory_workers.html'
    controller: 'LaboratoryWorkersCtrl'
]

.controller 'LaboratoryWorkersCtrl',
["$scope", "LaboratoryWorker", "LaboratoryTask"
($scope, LaboratoryWorker, LaboratoryTask) ->
  # worker list
  $scope.workers = LaboratoryWorker.query ->
    $scope.workers.forEach (item) ->
      calculate_balance(item)


    #  create_worker
    # ------------------------------------------------------------------------
    # create new laboratory worker
  $scope.create_worker = (name) ->
    worker = new LaboratoryWorker(name: name)
    worker.$save().then (worker) ->
      toastr.success "El laboratorista #{name} fue creado con éxito"
      $scope.workers = $scope.workers.concat([worker])
      $scope.name = ""
    .catch ->
      toastr.error 'Error al crear laboratorista'

  #  delete_worker
  # ------------------------------------------------------------------------
  # remove laboratory worker
  $scope.delete = (worker) ->
    worker.$delete().then ->
      toastr.success "Registro eliminado con éxito"
      $scope.workers = $scope.workers.filter (item)-> item._id != worker._id

  #  calculate_balance
  # ------------------------------------------------------------------------
  # calculate total
  calculate_balance = (worker) ->
    list = LaboratoryTask.query(worker:worker._id, ->
      total = 0
      total += item.balance for item in list
      worker.balance = total
    )
]
