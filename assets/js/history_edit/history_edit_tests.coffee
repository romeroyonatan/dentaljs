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
    $httpBackend.whenGET('/persons').respond 200
    # create new controller
    controller = $controller 'HistoryEditCtrl',
                             '$scope': $scope,

  # Yes-No question's tests
  # --------------------------------------------------------------------------
  it 'should process yes-no answers without comment', ->
    $scope.questions = [
      {
        _id: 'foo'
        statement: 'foo'
        yes_no: yes
        can_comment: no
        answer:
          choices: yes
      }
    ]
    promise = $scope.build $scope.questions
    promise.then (answers) ->
      expect(answers?).toBe true
      expect(answers[0].choices).toBe yes
      expect(answers[0].question._id).toEqual 'foo'
      expect(answers[0].comment?).toBe no

  it 'should process yes-no answers with comment', ->
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

  # Single-choice question's tests
  # --------------------------------------------------------------------------
  it 'should process single-choice answers without comments', ->
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

  it 'should process single-choice answers with comments', ->
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

  # Multiple-choice question's tests
  # --------------------------------------------------------------------------
  it 'should process multiple-choice answers without comments', ->
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

  it 'should process multiple-choice answers with comments', ->
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

  it 'should process multiple-choice answers all selected', ->
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

  # Grouped-choice question's tests
  # --------------------------------------------------------------------------
  it 'should process grouped-choice answers without comments', ->
    $scope.questions = [
      {
        _id: 'foo'
        statement: 'foo'
        choices: [
          [ {title:'x'}, {title:'y'}, {title:'z'} ] # Group #1
          [ {title:'a'}, {title:'b'}, {title:'c'} ] # Group #2
        ]
        can_comment: no
        selected: ['z', 'a']
      }
    ]
    promise = $scope.build $scope.questions
    promise.then (answers) ->
      expect(answers?).toBe true
      expect(answers[0].question._id).toEqual 'foo'
      expect(answers[0].choices.indexOf 'a').toBeGreaterThan -1
      expect(answers[0].choices.indexOf 'b').toEqual -1
      expect(answers[0].choices.indexOf 'z').toBeGreaterThan -1
      expect(answers[0].comment?).toBe false

  xit 'should process grouped-choice answers with comments', ->
    $scope.questions = [
      {
        _id: 'foo'
        statement: 'foo'
        choices: [
          [ {title:'x'}, {title:'y'}, {title:'z'} ] # Group #1
          [ {title:'a'}, {title:'b'}, {title:'c'} ] # Group #2
        ]
        can_comment: yes
        selected: ['z', 'a']
        answers:
          comment: 'bar'
      }
    ]
    promise = $scope.build $scope.questions
    promise.then (answers) ->
      expect(answers?).toBe true
      expect(answers[0].question._id).toEqual 'foo'
      expect(answers[0].choices.indexOf 'a').toBeGreaterThan -1
      expect(answers[0].choices.indexOf 'z').toBeGreaterThan -1
      expect(answers[0].comment).toEqual 'bar'

  # Open question's tests
  # --------------------------------------------------------------------------
  it 'should process open answers', ->
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

  # Other tests
  # --------------------------------------------------------------------------
  it 'should update already answered responses', ->
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

  it 'should ignore not answered responses', ->
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
    promise.then (answers) -> expect(answers.length).toEqual 0

  it 'should ignore existing and not answered responses', ->
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
    promise.then (answers) -> expect(answers.length).toEqual 0
