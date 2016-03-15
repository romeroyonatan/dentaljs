#= require directives
#= require filters
#= require services
#= require patients/patients
angular.module 'myApp', [
  'ngRoute',
  'personServices',
  'dentaljs.patients',
]

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.otherwise {redirectTo: '/patients'}
]
