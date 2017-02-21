express = require 'express'
controller = require '../controllers/laboratory'

router = express.Router()

# CRUD worker
# ======================
router.get 'worker/', controller.list_worker
router.post 'worker/', controller.create_worker
router.get 'worker/:id', controller.get_worker
router.put 'worker/:id', controller.update_worker
router.delete 'worker/:id', controller.delete_worker

# CRUD tasks
# ======================
router.get 'worker/:worker/tasks', controller.list_task
router.post 'task/', controller.create_task
router.put 'task/:id', controller.update_task
router.delete 'task/:id', controller.delete_task

module.exports = router
