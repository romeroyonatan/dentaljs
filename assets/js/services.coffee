angular.module 'dentaljs.services', ['ngResource']
.factory 'Person', ['$resource', ($resource) ->
  return $resource 'persons/:id', {id: "@_id"},
    update:
      method: 'PUT'
]
.factory 'Accounting', ['$resource', ($resource) ->
  return $resource 'accounting/:id', {id: "@_id"},
    update:
      method: 'PUT'
]
