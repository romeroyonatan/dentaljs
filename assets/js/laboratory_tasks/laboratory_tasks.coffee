angular.module('dentaljs.laboratory_tasks', ['ngRoute', 'angular-confirm'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/laboratorios/:slug',
    templateUrl: '/partials/laboratory_tasks/laboratory_tasks.html'
    controller: 'LaboratoryTasksCtrl'
]

.controller 'LaboratoryTasksCtrl', [
  "$scope", "$routeParams", "LaboratoryTask", "LaboratoryWorker",
($scope, $routeParams, LaboratoryTask, LaboratoryWorker) ->
  # task list
  query = LaboratoryWorker.query(slug:$routeParams.slug, ->
    $scope.worker = query[0]
    $scope.tasks = LaboratoryTask.query(worker: $scope.worker._id)
  )

  #  create_task
  # ------------------------------------------------------------------------
  # create new laboratory task
  $scope.create_task = (task) ->
    task = Object.assign({}, task, worker: $scope.worker._id)
    task = new LaboratoryTask(task)
    task.$save().then (task) ->
      toastr.success "La tarea #{task.name} fue creado con éxito"
      $scope.tasks = $scope.tasks.concat([task])
      $scope.task = {}
    .catch ->
      toastr.error 'Error al crear la tarea'

  #  delete
  # ------------------------------------------------------------------------
  # remove laboratory task
  $scope.delete = (task) ->
    task.$delete().then ->
      toastr.success "Tarea eliminado con éxito"
      $scope.tasks = $scope.tasks.filter (item)-> item._id != task._id

  #  get_total
  # ------------------------------------------------------------------------
  # calculate total
  $scope.get_total = ->
    total = 0
    total += item.balance for item in $scope.tasks
    return total
]
