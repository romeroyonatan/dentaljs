#= require directives
#= require filters
#= require services
#= require patient_list/patient_list
#= require patient_create/patient_create
#= require patient_delete/patient_delete
#= require patient_update/patient_update
#= require patient_detail/patient_detail
#= require patient_history/patient_history
#= require patient_treatment/patient_treatment
#= require patient_payments/patient_payments

angular.module 'dentaljs', [
  'ngRoute',
  'dentaljs.services',
  'dentaljs.patient_list',
  'dentaljs.patient_create',
  'dentaljs.patient_delete',
  'dentaljs.patient_update',
  'dentaljs.patient_detail',
  'dentaljs.patient_history',
  'dentaljs.patient_treatment',
  'dentaljs.patient_payments',
]

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.otherwise {redirectTo: '/patients'}
]
