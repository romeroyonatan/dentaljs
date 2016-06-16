describe 'dentaljs.history_edit module', ->
  $scope = null
  $httpBackend = null
  controller = null

  beforeEach module 'dentaljs.services'
  beforeEach module 'dentaljs.history_edit'

  beforeEach inject ($injector) ->
    # Get hold of a scope (i.e. the root scope)
    $scope = $injector.get '$rootScope'
    # The $controller service is used to create instances of controllers
    $controller = $injector.get '$controller'
    $httpBackend = $injector.get '$httpBackend'
    $httpBackend.whenGET('/persons').respond 200, _id: 'foo'
    $httpBackend.whenGET('/questions').respond 200
    $httpBackend.whenGET('/questions/undefined').respond 200
    $httpBackend.whenGET('/questions/foo').respond 200
    # create new controller
    controller = $controller 'HistoryEditCtrl',
                             '$scope': $scope,

  # Yes-No question's tests
  # --------------------------------------------------------------------------
  it 'should process yes-no answers without comment', (done) ->
    $scope.questions = [
      {
        _id: 'foo'
        statement: 'foo'
        yes_no: yes
        can_comment: no
        answer:
          choices: no
      }
    ]
    $scope.build($scope.questions).then (answers) ->
      expect(answers?).toBe true
      expect(answers[0].choices).toBe no
      expect(answers[0].question._id).toEqual 'foo'
      expect(answers[0].comment?).toBe no
      done()
    $httpBackend.flush()

  it 'should process yes-no answers with comment', (done) ->
    $scope.questions = [
      {
        _id: 'foo'
        statement: 'foo'
        yes_no: yes
        can_comment: yes
        answer:
          choices: no
          comment: 'bar'
      }
    ]
    promise = $scope.build $scope.questions
    promise.then (answers) ->
      expect(answers?).toBe true
      expect(answers[0].choices).toBe no
      expect(answers[0].question._id).toEqual 'foo'
      expect(answers[0].comment).toEqual 'bar'
      done()
    $httpBackend.flush()

  # Single-choice question's tests
  # --------------------------------------------------------------------------
  it 'should process single-choice answers without comments', (done) ->
    $scope.questions = [
      {
        _id: 'foo'
        statement: 'foo'
        choices: [[{title: 'x'}, {title:'y'}, {title:'z'}]]
        can_comment: no
        multiple_choice: no
        answer:
          choices: {title:'x'}
          comment: 'bar'
      }
    ]
    promise = $scope.build $scope.questions
    promise.then (answers) ->
      expect(answers?).toBe true
      expect(answers[0].question._id).toEqual 'foo'
      expect(answers[0].choices).toEqual 'x'
      expect(answers[0].comment?).toBe no
      done()
    $httpBackend.flush()

  it 'should process single-choice answers with comments', (done) ->
    $scope.questions = [
      {
        _id: 'foo'
        statement: 'foo'
        choices: [[{title: 'x'}, {title:'y'}, {title:'z'}]]
        can_comment: yes
        multiple_choice: no
        answer:
          choices: {title:'y'}
          comment: 'bar'
      }
    ]
    promise = $scope.build $scope.questions
    promise.then (answers) ->
      expect(answers?).toBe true
      expect(answers[0].question._id).toEqual 'foo'
      expect(answers[0].choices).toEqual 'y'
      expect(answers[0].comment).toEqual 'bar'
      done()
    $httpBackend.flush()

  # Multiple-choice question's tests
  # --------------------------------------------------------------------------
  it 'should process multiple-choice answers without comments', (done) ->
    $scope.questions = [
      {
        _id: 'foo'
        statement: 'foo'
        choices: [[
          {title: 'x'}
          {title:'y', selected: yes}
          {title:'z', selected: yes}
        ]]
        can_comment: no
        multiple_choice: yes
        answer:
          choices: [{title:'y'}]
      }
    ]
    promise = $scope.build $scope.questions
    promise.then (answers) ->
      expect(answers?).toBe true
      expect(answers[0].question._id).toEqual 'foo'
      expect(answers[0].choices.indexOf 'x').toEqual -1
      expect(answers[0].choices.indexOf 'y').toBeGreaterThan -1
      expect(answers[0].choices.indexOf 'z').toBeGreaterThan -1
      expect(answers[0].comment?).toBe false
      done()
    $httpBackend.flush()

  it 'should process multiple-choice answers with comments', (done) ->
    $scope.questions = [
      {
        _id: 'foo'
        statement: 'foo'
        choices: [[
          {title: 'x', selected: yes}
          {title:'y', selected: no}
          {title:'z', selected: yes}
        ]]
        can_comment: yes
        multiple_choice: yes
        answer:
          choices: [{title:'y'}]
          comment: 'bar'
      }
    ]
    promise = $scope.build $scope.questions
    promise.then (answers) ->
      expect(answers?).toBe true
      expect(answers[0].question._id).toEqual 'foo'
      expect(answers[0].choices.indexOf 'x').toBeGreaterThan -1
      expect(answers[0].choices.indexOf 'y').toEqual -1
      expect(answers[0].choices.indexOf 'z').toBeGreaterThan -1
      expect(answers[0].comment).toEqual 'bar'
      done()
    $httpBackend.flush()

  it 'should process multiple-choice answers all selected', (done) ->
    $scope.questions = [
      {
        _id: 'foo'
        statement: 'foo'
        choices: [[
          {title: 'x', selected: yes}
          {title:'y', selected: yes}
          {title:'z', selected: yes}
        ]]
        can_comment: no
        multiple_choice: yes
        answer:
          choices: [{title:'y'}]
      }
    ]
    promise = $scope.build $scope.questions
    promise.then (answers) ->
      expect(answers?).toBe true
      expect(answers[0].choices.indexOf 'x').toBeGreaterThan -1
      expect(answers[0].choices.indexOf 'y').toBeGreaterThan -1
      expect(answers[0].choices.indexOf 'z').toBeGreaterThan -1
      done()
    $httpBackend.flush()

  # Grouped-choice question's tests
  # --------------------------------------------------------------------------
  it 'should process grouped-choice answers without comments', (done) ->
    $scope.questions = [
      _id: 'foo'
      statement: 'foo'
      choices: [
        [ {title:'x'}, {title:'y'}, {title:'z'} ] # Group #1
        [ {title:'a'}, {title:'b'}, {title:'c'} ] # Group #2
      ]
      can_comment: no
      selected: [{title:'z'}, {title:'a'}]
    ]
    promise = $scope.build $scope.questions
    promise.then (answers) ->
      expect(answers?).toBe true
      expect(answers[0].question._id).toEqual 'foo'
      expect(answers[0].choices.indexOf 'a').toBeGreaterThan -1
      expect(answers[0].choices.indexOf 'b').toEqual -1
      expect(answers[0].choices.indexOf 'z').toBeGreaterThan -1
      expect(answers[0].comment?).toBe false
      done()
    $httpBackend.flush()

  it 'should process grouped-choice answers with comments', (done) ->
    $scope.questions = [
      _id: 'foo'
      statement: 'foo'
      choices: [
        [ {title:'x'}, {title:'y'}, {title:'z'} ] # Group #1
        [ {title:'a'}, {title:'b'}, {title:'c'} ] # Group #2
      ]
      can_comment: yes
      selected: [{title:'z'}, {title:'a'}]
      answer:
        comment: 'bar'
    ]
    promise = $scope.build $scope.questions
    promise.then (answers) ->
      expect(answers?).toBe true
      expect(answers[0].question._id).toEqual 'foo'
      expect(answers[0].choices.indexOf 'a').toBeGreaterThan -1
      expect(answers[0].choices.indexOf 'z').toBeGreaterThan -1
      expect(answers[0].comment).toEqual 'bar'
      done()
    $httpBackend.flush()

  # Open question's tests
  # --------------------------------------------------------------------------
  it 'should process open answers', (done) ->
    $scope.questions = [
      {
        _id: 'foo'
        statement: 'foo'
        can_comment: yes
        answer:
          comment: 'bar'
      }
    ]
    promise = $scope.build $scope.questions
    promise.then (answers) ->
      expect(answers?).toBe true
      expect(answers[0].question._id).toEqual 'foo'
      expect(answers[0].comment).toEqual 'bar'
      done()
    $httpBackend.flush()

  # Other tests
  # --------------------------------------------------------------------------
  it 'should update already answered responses', (done) ->
    $scope.answers = [
      {
        question: _id: 'foo'
        comment: 'foo'
      }
    ]
    $scope.questions = [
      {
        _id: 'foo'
        statement: 'foo'
        can_comment: yes
        answer:
          comment: 'bar'
      }
    ]
    promise = $scope.build $scope.questions
    promise.then (answers) ->
      expect(answers?).toBe true
      expect(answers.length).toEqual 1
      expect(answers[0].question._id).toEqual 'foo'
      expect(answers[0].comment).toEqual 'bar'
      done()
    $httpBackend.flush()

  it 'should ignore not answered responses', (done) ->
    $scope.questions = [
      { # * Open question
        _id: 'open'
        statement: 'foo'
        can_comment: yes
      },
      { # * yes/no question
        _id: 'yes-no'
        statement: 'foo'
        yes_no: yes
        can_comment: yes
      },
      { # * single-choice question
        _id: 'single-choice'
        statement: 'foo'
        choices: [[{title:'x'}, {title:'y'}, {title:'z'}]]
        can_comment: yes
      },
      { # * multiple-choice question
        _id: 'multiple-choice'
        statement: 'foo'
        choices: [[{title:'x'}, {title:'y'}, {title:'z'}]]
        multiple_choice: yes
        can_comment: yes
      },
      { # * grouped-choice question
        _id: 'grouped-choice'
        statement: 'foo'
        choices: [
          [{title:'x'}, {title:'y'}, {title:'z'}]
          [{title:'a'}, {title:'b'}, {title:'c'}]
        ]
        can_comment: yes
      },
    ]
    promise = $scope.build $scope.questions
    promise.then (answers) ->
      expect(answers.length).toEqual 0
      done()
    $httpBackend.flush()

  it 'should ignore existing and not answered responses', (done) ->
    $scope.answers = [
      { # * Open question
        question: _id: 'open'
        comment: 'bar'
      },
    ]
    $scope.questions = [
      { # * Open question
        _id: 'open'
        statement: 'foo'
        can_comment: yes
      },
      { # * yes/no question
        _id: 'yes-no'
        statement: 'foo'
        yes_no: yes
        can_comment: yes
      },
    ]
    promise = $scope.build $scope.questions
    promise.then (answers) ->
      expect(answers.length).toEqual 0
      done()
    $httpBackend.flush()

  # load answers' tests
  # --------------------------------------------------------------------------
  it 'should load open answers', (done)->
    answers = [
      question: _id: 'open'
      comment: 'bar'
    ]
    questions = [
      _id: 'open'
      statement: 'foo'
      can_comment: yes
    ]
    $scope.loadAnswers(questions, answers).then ->
      expect(questions[0].answer.comment).toEqual 'bar'
      done()
    $httpBackend.flush()

  it 'should load yes-no answers', (done)->
    answers = [
      {
        question: _id: 'yes-no'
        choices: yes
        comment: 'bar'
      },
    ]
    questions = [
      _id: 'yes-no'
      statement: 'foo'
      can_comment: yes
      yes_no: yes
    ]
    $scope.loadAnswers(questions, answers).then ->
      expect(questions[0].answer.choices).toBe yes
      expect(questions[0].answer.comment).toEqual 'bar'
      done()
    $httpBackend.flush()

  it 'should load single-choice answers', (done)->
    answers = [
      {
        question: _id: 'yes-no'
        choices: 'a'
      },
    ]
    questions = [
      _id: 'yes-no'
      statement: 'foo'
      choices: [[ {title:'a'}, {title:'b'}, {title:'c'} ]]
      multiple_choice: no
    ]
    $scope.loadAnswers(questions, answers).then ->
      expect(questions[0].answer.choices.title).toBe 'a'
      done()
    $httpBackend.flush()

  #TODO loadQuestion tests
