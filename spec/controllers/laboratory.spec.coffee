controller = require '../../.app/controllers/laboratory'
LaboratoryWorker = require '../../.app/models/laboratory_worker'
LaboratoryTask = require '../../.app/models/laboratory_task'

describe 'Laboratories test suite', ->
  afterEach (done) ->
    LaboratoryTask.remove({})
    .then -> LaboratoryWorker.remove({})
    .then done

  describe 'laboratory worker crud tests', ->
    it 'should create new laboratory worker', (done) ->
      res =
        # el codigo que devuelve debe ser 201
        status: (status_code) ->
          expect(status_code).toBe 201
          return @
        send: (worker)->
          expect(worker).not.toBeNull()
          expect(worker.name).toEqual 'foo'
          done()
      req = body: name: 'foo'
      controller.create_worker req, res, done.fail

    it 'should update laboratory worker', (done) ->
      LaboratoryWorker.create(name:'foo')
      .then (old)->
        res =
          send: ->
            LaboratoryWorker
              .findOne(_id: old._id)
              .then (laboratory_worker) ->
                expect(laboratory_worker.name).toBe 'bar'
              .then done
        req =
          params: id: old._id
          body: name: 'bar'
        controller.update_worker req, res, done.fail
      .catch done.fail

    it 'should delete laboratory worker', (done) ->
      LaboratoryWorker.create(name:'foo')
      .then (old)->
        res =
          # el codigo que devuelve debe ser 204
          status: (status_code) ->
            expect(status_code).toBe 204
            return @
          end: ->
            LaboratoryWorker
              .findOne(_id: old._id)
              .then (laboratory_worker) ->
                expect(laboratory_worker).toBeNull()
              .then done
        req =
          params: id: old._id
          body: name: 'bar'
        controller.delete_worker req, res, done.fail
      .catch done.fail

    it 'should get details of laboratory worker', (done) ->
      LaboratoryWorker.create(name:'foo')
      .then (worker)->
        res =
          send: (item)->
            expect(item._id).toEqual worker._id
            expect(item.name).toEqual worker.name
            done()
        req =
          params: slug: worker.slug
        controller.get_worker req, res, done.fail
      .catch done.fail

    it 'should list of laboratory workers', (done) ->
      LaboratoryWorker.create(name:'foo')
      .then (worker)->
        res =
          send: (list)->
            expect(list.length).toBe 1
            expect(list[0]._id).toEqual worker._id
            done()
        controller.list_worker {}, res, done.fail
      .catch done.fail

  describe 'laboratory task crud tests', ->
    it 'should create new laboratory task', (done) ->
      LaboratoryWorker.create(name:'foo')
      .then (worker)->
        res =
          status: (status_code) ->
            expect(status_code).toBe 201
            return @
          send: (task)->
            expect(task).not.toBeNull()
            expect(task.name).toEqual 'bar'
            expect(task.debit).toEqual 1
            expect(task.assets).toEqual 0
            expect(task.balance).toEqual -1
            expect(task.worker).toEqual worker._id
            done()
        req = body: {name: 'bar', debit: 1, worker: worker._id}
        controller.create_task req, res, done.fail
      .catch done.fail

    it 'should update laboratory task', (done) ->
      LaboratoryWorker.create(name:'foo').then (worker)->
        LaboratoryTask.create({
          name:'foo',
          debit: 1
          worker: worker
        }).then (task)->
          res =
            send: (task) ->
              LaboratoryTask.findById(task._id).then (task) ->
                expect(task.assets).toBe 1
                expect(task.debit).toBe 1
                expect(task.balance).toBe 0
              .then done
          req =
            params: id: task._id
            body: assets: 1, debit: 1, name: 'foo'
          controller.update_task req, res, done.fail
      .catch done.fail

    it 'should delete laboratory task', (done) ->
      LaboratoryWorker.create(name:'foo').then (worker)->
        LaboratoryTask.create({
          name:'foo',
          debit: 1
          worker: worker
        }).then (task)->
          res =
            # el codigo que devuelve debe ser 204
            status: (status_code) ->
              expect(status_code).toBe 204
              return @
            end: ->
              LaboratoryTask
                .findById(task._id)
                .then (task) -> expect(task).toBeNull()
                .then done
          req =
            params: id: task._id
          controller.delete_task req, res, done.fail
      .catch done.fail

    it 'should list laboratory tasks', (done) ->
      LaboratoryWorker.create(name:'foo').then (worker)->
        LaboratoryTask.create({
          name:'foo',
          debit: 1
          worker: worker
        }).then (task) ->
          res =
            send: (list) ->
              expect(list.length).toBe 1
              expect(list[0]._id).toEqual task._id
              done()
          req =
            query: worker: worker._id
          controller.list_task req, res, done.fail
      .catch done.fail
