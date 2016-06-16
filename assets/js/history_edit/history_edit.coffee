angular.module('dentaljs.history_edit', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/history/edit',
    templateUrl: '/partials/history_edit/history_edit.html'
    controller: 'HistoryEditCtrl'
]

.controller 'HistoryEditCtrl', [
  "$scope", "$routeParams", "$location", "$q", "$http", "Person"
  ($scope, $routeParams, $location, $q, $http, Person) ->
    TYPE =
      OPEN: 0
      YES_NO: 1
      SINGLE_CHOICE: 2
      MULTIPLE_CHOICE: 3
      GROUPED_CHOICE: 4

    $scope.answers = []
    $scope.questions = []
    $scope.loading = yes

    $scope.patient = Person.get slug: $routeParams.slug, ->
      # Get questions' list
      $scope.loadQuestions()
      .then ->
        $http.get("/questions/"+ $scope.patient._id).then (res)->
          $scope.answers = res.data
          $scope.loadAnswers $scope.questions, $scope.answers
      .then ->
        $scope.loading = no

    # loadQuestions
    # ------------------------------------------------------------------------
    # Load questions saved in database
    $scope.loadQuestions = ->
      $http.get("/questions").then (res)-> $q (resolve)->
        $scope.questions = res.data
        for question in $scope.questions
          question.type = switch
            when question.yes_no then TYPE.YES_NO
            when question.choices?.length > 1 then TYPE.GROUPED_CHOICE
            when question.choices?.length == 1 and question.multiple_choice
              TYPE.MULTIPLE_CHOICE
            when question.choices?.length == 1 and !question.multiple_choice
              TYPE.SINGLE_CHOICE
            when question.choices?.length > 1 then TYPE.GROUPED_CHOICE
            else TYPE.OPEN
        resolve()

    # loadAnswers
    # ------------------------------------------------------------------------
    # Load answers saved in database
    $scope.loadAnswers = (questions, answers) -> $q (resolve) ->
      # Get answers' list
      for answer in answers
        # find question
        question = questions?.find (q)-> q._id is answer.question._id
        # load answer
        question.answer =
          comment: answer.comment
          choices: answer.choices
      resolve()

    # single_choice (question, answer)
    # ------------------------------------------------------------------------
    # Process single-choice answer and its comment and return if the question
    # was aswered
    single_choice = (question, answer) ->
      answer.choices = question.answer?.choices.title
      answer.comment = question.answer?.comment if question.can_comment

    # multiple_choice (question, answer)
    # ------------------------------------------------------------------------
    # Process multiple-choice answer and its comment and return if the question
    # was aswered
    multiple_choice = (question, answer) ->
      selected = question.choices[0].filter (choice)-> choice.selected
      answer.choices = (choice.title for choice in selected)
      answer.comment = question.answer?.comment if question.can_comment

    # grouped_choice (question, answer)
    # ------------------------------------------------------------------------
    # Process grouped-choice answer and its comment and return if the question
    # was aswered
    grouped_choice = (question, answer) ->
      if question.selected?
        answer.choices = (item?.title for item in question.selected)
      answer.comment = question.answer?.comment if question.can_comment

    # yes_no (question, answer)
    # ------------------------------------------------------------------------
    # Process Yes/No answer and its comment and return if the question
    # was aswered
    yes_no = (question, answer) ->
      answer.choices = question.answer?.choices
      answer.comment = question.answer?.comment if question.can_comment

    # open_question (question, answer)
    # ------------------------------------------------------------------------
    # Process open answer and return if the question was aswered
    open_question = (question, answer) ->
      answer.comment = question.answer?.comment if question.can_comment

    is_aswered = (answer) ->
      answer.choices is false or answer.choices?.length > 0 or answer.comment?

    # $scope.build (questions)
    # ------------------------------------------------------------------------
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
        $scope.answers.push answer if answer.is_new

      # resolve promise
      resolve $scope.answers.filter is_aswered

    $scope.send = ->
      $scope.build($scope.questions).then (answers)->
        $http.post("/questions/" + $scope.patient._id, answers: answers)
        .then ->
          toastr.success "Historia clínica actualizada con éxito"
          $location.path "/patients/#{$routeParams.slug}/history"
        .catch (err) -> toastr.error "Hubo un error al intentar actualizar la
                                      historia clínica"

]
