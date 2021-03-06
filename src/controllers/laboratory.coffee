LaboratoryWorker = require '../../.app/models/laboratory_worker'
LaboratoryTask = require '../../.app/models/laboratory_task'

module.exports =
  # list_worker
  # --------------------------------------------------------------------------
  # Get laboratory workers
  list_worker: (req, res, next) ->
    LaboratoryWorker.find(req.query)
    .then (list) -> res.send(list)
    .catch (err) -> next err

  # create_worker
  # --------------------------------------------------------------------------
  # Create new laboratory worker
  create_worker: (req, res, next) ->
    LaboratoryWorker.create(req.body)
    .then (worker) -> res.status(201).send(worker)
    .catch (err) -> next err

  # update_worker
  # --------------------------------------------------------------------------
  # Update laboratory worker attributes
  update_worker: (req, res, next) ->
    LaboratoryWorker.findByIdAndUpdate(req.params.id, req.body)
    .then (worker) ->
      return next(status:404, message: 'Worker not found') if not worker?
      res.send(worker)
    .catch (err) -> next err

  # delete_worker
  # --------------------------------------------------------------------------
  # Delete laboratory worker
  delete_worker: (req, res, next) ->
    LaboratoryWorker.findByIdAndRemove(req.params.id)
    .then (worker)->
      return next(status:404, message: 'Worker not found') if not worker?
      res.status(204).end()
    .catch (err) -> next err

  # get_worker
  # --------------------------------------------------------------------------
  # Get laboratory worker details
  get_worker: (req, res, next) ->
    LaboratoryWorker.findOne(slug: req.params.slug)
    .then (worker) ->
      return next(status:404, message: 'Worker not found') if not worker?
      res.send worker
    .catch (err) -> next err

  # list_task
  # --------------------------------------------------------------------------
  # List task of a worker
  list_task: (req, res, next) ->
    LaboratoryTask.find(req.query)
    .then (list) -> res.send(list)
    .catch (err) -> next errk

  # create_task
  # --------------------------------------------------------------------------
  # Create new laboratory task
  create_task: (req, res, next) ->
    LaboratoryTask.create(req.body)
    .then (task) -> res.status(201).send(task)
    .catch (err) -> next errk

  # update_task
  # --------------------------------------------------------------------------
  # Update new laboratory task
  update_task: (req, res, next) ->
    LaboratoryTask.findByIdAndUpdate(req.params.id, req.body, new: true)
    .then (task) ->
      return next(status: 404, message: 'Task not found') if not task?
      # update balance because Mongoose doesnt do in pre-save hook
      task.balance = task.assets - task.debit
      task.save().then (task) ->
        res.send task
    .catch (err) -> next err

  # delete task
  # --------------------------------------------------------------------------
  # Remove laboratory task
  delete_task: (req, res, next) ->
    LaboratoryTask.findByIdAndRemove(req.params.id)
    .then (task) ->
      return next(status: 404, message: 'Task not found') if not task?
      res.status(204).end()
    .catch (err) -> next err

  # get_task
  # --------------------------------------------------------------------------
  # Get laboratory task details
  get_task: (req, res, next) ->
    LaboratoryTask.findById(req.params.id)
    .then (task) ->
      return next(status:404, message: 'Worker not found') if not task?
      res.send task
    .catch (err) -> next err
