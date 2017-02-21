express = require 'express'
controller = require '../controllers/laboratory'

router = express.Router()

# CRUD worker
# ======================
router.get '/workers/', controller.list_worker
router.post '/workers/', controller.create_worker
router.get '/workers/:id', controller.get_worker
router.put '/workers/:id', controller.update_worker
router.delete '/workers/:id', controller.delete_worker

# CRUD tasks
# ======================
router.get '/tasks', controller.list_task
router.get '/tasks/:id', controller.get_task
router.post '/tasks/', controller.create_task
router.put '/tasks/:id', controller.update_task
router.delete '/tasks/:id', controller.delete_task

module.exports = router
