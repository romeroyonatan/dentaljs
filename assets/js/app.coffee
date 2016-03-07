#= require directives
#= require filters
#= require patients/patients
angular.module 'myApp', [
  'ngRoute',
  'myApp.patients',
]

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.otherwise {redirectTo: '/patients'}
]
