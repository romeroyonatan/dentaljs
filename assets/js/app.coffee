#= require directives
#= require filters
#= require services
#= require patient_list/patient_list
#= require patient_form/patient_form
#= require patient_delete/patient_delete
#= require patient_detail/patient_detail
#= require patient_history/patient_history
#= require patient_treatment/patient_treatment
#= require patient_payments/patient_payments
#= require patient_gallery/patient_gallery
#= require odontogram_edit/odontogram_edit
#= require odontogram_list/odontogram_list
#= require odontogram_detail/odontogram_detail

angular.module 'dentaljs', [
  'ngRoute',
  'ngAnimate',
  'dentaljs.services',
  'dentaljs.patient_list',
  'dentaljs.patient_form',
  'dentaljs.patient_delete',
  'dentaljs.patient_detail',
  'dentaljs.patient_history',
  'dentaljs.patient_treatment',
  'dentaljs.patient_payments',
  'dentaljs.patient_gallery',
  'dentaljs.odontogram_edit',
  'dentaljs.odontogram_list',
  'dentaljs.odontogram_detail',
]

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.otherwise {redirectTo: '/patients'}
]

# Simple error handling
.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push ['$q', ($q) ->
    responseError: (rejection) ->
      switch rejection.status
        when 401, 404 then window.location = "/"
        else $q.reject(rejection)
    ]
]
