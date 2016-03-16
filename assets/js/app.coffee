#= require directives
#= require filters
#= require services
#= require patient_list/patient_list
#= require patient_create/patient_create
#= require patient_delete/patient_delete
#= require patient_detail/patient_detail
#= require patient_update/patient_update


angular.module 'dentaljs', [
  'ngRoute',
  'personServices',
  'dentaljs.patient_list',
  'dentaljs.patient_create',
  'dentaljs.patient_delete',
  'dentaljs.patient_detail',
  'dentaljs.patient_update',
]

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.otherwise {redirectTo: '/patients'}
]
