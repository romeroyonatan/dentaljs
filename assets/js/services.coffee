angular.module 'dentaljs.services', ['ngResource']
.factory 'Person', ['$resource', ($resource) ->
  return $resource '/persons/:slug', {slug: "@slug"}, update: method: 'PUT'
]
.factory 'Accounting', ['$resource', ($resource) ->
  return $resource '/accounting/:id', {id: "@_id"}, update: method: 'PUT'
]
.factory 'Odontogram', ['$resource', ($resource) ->
  return $resource '/odontograms/:id', {id: "@_id"}, update: method: 'PUT'
]
.factory 'Issue', ['$resource', ($resource) ->
  return $resource '/odontograms/issues/:id', {id: "@_id"},
    update: method: 'PUT'
]
.factory 'Product', ['$resource', ($resource) ->
  return $resource '/costs/direct/products/:id', {id: "@_id"},
    update: method: 'PUT'
]
.factory 'LaboratoryWorker', ['$resource', ($resource) ->
  return $resource '/laboratory/workers/:id', {id: "@_id"},
    update: method: 'PUT'
]
.factory 'LaboratoryTask', ['$resource', ($resource) ->
  return $resource '/laboratory/tasks/:id', {id: "@_id"},
    update: method: 'PUT'
]
