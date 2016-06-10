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
    $scope.answers = []

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

    # single_choice (question, answer)
    # --------------------------------------------------------------------------
    # Process single-choice answer and its comment
    single_choice = (question, answer) ->
      answer.choices = question.answer.choices
      answer.comment = question.answer.comment if question.can_comment

    # multiple_choice (question, answer)
    # --------------------------------------------------------------------------
    # Process multiple-choice answer and its comment
    multiple_choice = (question, answer) ->
      answer.choices = question.answer.choices.filter (choice)-> choice.selected
      answer.comment = question.answer.comment if question.can_comment

    # grouped_choice (question, answer)
    # --------------------------------------------------------------------------
    # Process grouped-choice answer and its comment
    grouped_choice = (question, answer) ->
      answer.choices = (choice.title for choice in question.selected)
      answer.comment = question.answer.comment if question.can_comment

    # yes_no (question, answer)
    # --------------------------------------------------------------------------
    # Process Yes/No answer and its comment
    yes_no = (question, answer) ->
      answer.choices = question.answer.choices
      answer.comment = question.answer.comment if question.can_comment

    # open_question (question, answer)
    # --------------------------------------------------------------------------
    # Process open answer
    open_question = (question, answer) ->
      answer.comment = question.answer.comment if question.can_comment

    # $scope.build (questions)
    # --------------------------------------------------------------------------
    # Build an answer's array from questions
    $scope.build = (questions) ->
      questions.forEach (question) ->
        # find answer if its was answered previously
        answer = $scope.answers.find (answer)->
          answer.question._id == question._id

        #if answer wasnt answered previously, create new
        if not answer?
          answer =
            person: $scope.patient
            question: question

        # ### process answer by its type
        # * Yes/No
        if question.yes_no
          yes_no question, answer

        # * Multiple Choice
        else if question.choices.length == 1 and question.multiple_choice
          multiple_choice question, answer

        # * Single choice
        else if question.choices.length == 1 and not question.multiple_choice
          single_choice question, answer

        # * Grouped choice
        else if question.choices.length > 1
          grouped_choice question, answer

        # * Open questiions
        else
          open_question question, answer

        # push answer in array
        $scope.answers.push answer

        # return new answer's array
        return $scope.answers
]
