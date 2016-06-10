angular.module('dentaljs.history_edit', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/history/edit',
    templateUrl: '/partials/history_edit/history_edit.html'
    controller: 'HistoryEditCtrl'
]

.controller 'HistoryEditCtrl', [
  "$scope", "$routeParams", "$location", "$q", "Person"
  ($scope, $routeParams, $location, $q, Person) ->
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
    # Process single-choice answer and its comment and return if the question
    # was aswered
    single_choice = (question, answer) ->
      answer.choices = question.answer?.choices.title
      answer.comment = question.answer?.comment if question.can_comment
      return answer.choices? or answer.comment?

    # multiple_choice (question, answer)
    # --------------------------------------------------------------------------
    # Process multiple-choice answer and its comment and return if the question
    # was aswered
    multiple_choice = (question, answer) ->
      selected = question.choices[0].filter (choice)-> choice.selected
      answer.choices = (choice.title for choice in selected)
      answer.comment = question.answer?.comment if question.can_comment
      return answer.choices?.length > 0 or answer.comment?

    # grouped_choice (question, answer)
    # --------------------------------------------------------------------------
    # Process grouped-choice answer and its comment and return if the question
    # was aswered
    grouped_choice = (question, answer) ->
      answer.choices = question.selected
      answer.comment = question.answer?.comment if question.can_comment
      return answer.choices? or answer.comment?

    # yes_no (question, answer)
    # --------------------------------------------------------------------------
    # Process Yes/No answer and its comment and return if the question
    # was aswered
    yes_no = (question, answer) ->
      answer.choices = question.answer?.choices
      answer.comment = question.answer?.comment if question.can_comment
      return answer.choices? or answer.comment?

    # open_question (question, answer)
    # --------------------------------------------------------------------------
    # Process open answer and return if the question was aswered
    open_question = (question, answer) ->
      answer.comment = question.answer?.comment if question.can_comment
      return answer.comment?

    # $scope.build (questions)
    # --------------------------------------------------------------------------
    # Build an answer's array from questions
    $scope.build = (questions) -> $q (resolve, reject) ->
      questions.forEach (question) ->
        # find answer if its was answered previously
        answer = $scope.answers.find (answer) ->
          answer.question._id is question._id

        #if answer wasnt answered previously, create new
        if answer?
          answer.is_new = no
          answer.question = question # update question reference

        else
          answer =
            person: $scope.patient
            question: question
            is_new: yes

        # ### process answer by its type
        question.is_aswered =
          # * Yes/No
          if question.yes_no
            yes_no question, answer

          else if question.choices?.length == 1
            # * Multiple Choice
            if question.multiple_choice
              multiple_choice question, answer

            # * Single Choice
            else
              single_choice question, answer

          # * Grouped choice
          else if question.choices?.length > 1
            grouped_choice question, answer

          # * Open questions
          else
            open_question question, answer

        # push new answer in array
        $scope.answers.push answer if answer.is_new and question.is_aswered
        
      # resolve promise
      resolve $scope.answers.filter (answer)-> answer.question.is_aswered
]
