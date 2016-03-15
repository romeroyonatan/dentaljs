personServices = angular.module 'personServices', ['ngResource']

personServices.factory 'Person', ['$resource', ($resource) ->
  return $resource 'persons/:id', {id: "@_id"},
    update:
      method: 'PUT'
]
