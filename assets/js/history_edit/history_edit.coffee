angular.module('dentaljs.history_edit', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/history/edit',
    templateUrl: '/partials/history_edit/history_edit.html'
    controller: 'HistoryEditCtrl'
]

.controller 'HistoryEditCtrl', [
  "$scope", "$routeParams", "$location", "Person"
  ($scope, $routeParams, $location, Person) ->
    $scope.patient = Person.get slug: $routeParams.slug
    $scope.questions = [
      {
        statement: "Pregunta abierta"
        can_comment: yes
        help_text: "Ponga lo que quiera"
      }
      {
        statement: "Pregunta si-no"
        yes_no: yes
        can_comment: yes
        comment_title: "¿Qué mas desea agregar?"
        help_text: "seleccione si o no"
      }
      {
        statement: "Pregunta single choice"
        choices: [
          [
            {title: "A"},
            {title: "B"},
            {title: "C"},
          ]
        ]
        can_comment: no
        help_text: "Seleccione solo una opcion"
      }
      {
        statement: "Pregunta multiple choice"
        choices: [
          [
            {title: "x"},
            {title: "y"},
            {title: "z"},
          ]
        ]
        multiple_choice: yes
        can_comment: yes
        comment_title: "Otro"
        help_text: "Seleccione muchas opciones"
      }
      {
        statement: "Pregunta grouped choice"
        choices: [
          [
            {title: "x"},
            {title: "y"},
            {title: "z"},
          ]
          [
            {title: "a"},
            {title: "b"},
            {title: "c"},
          ]
        ]
        selected: [] # XXX Ojo agregue esto
        can_comment: yes
        comment_title: "Otro"
        help_text: "Seleccione opciones agrupadas"
      }
    ]
]
