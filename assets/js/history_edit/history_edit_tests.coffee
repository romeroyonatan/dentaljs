xdescribe 'dentaljs.history_edit module', ->
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
    answers = $scope.build $scope.questions
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
    answers = $scope.build $scope.questions
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
    answers = $scope.build $scope.questions
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
    answers = $scope.build $scope.questions
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
    answers = $scope.build $scope.questions
    expect(answers?).toBe true
    expect(answers[0].question._id).toEqual 'foo'
    expect(answers[0].choices.indexOf 'y').toBeGreaterThan -1
    expect(answers[0].choices.indexOf 'z').toBeGreaterThan -1
    expect(answers[0].comment?).toBe False

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
    answers = $scope.build $scope.questions
    expect(answers?).toBe true
    expect(answers[0].question._id).toEqual 'foo'
    expect(answers[0].choices.indexOf 'x').toBeGreaterThan -1
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
    answers = $scope.build $scope.questions
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
    answers = $scope.build $scope.questions
    expect(answers?).toBe true
    expect(answers[0].question._id).toEqual 'foo'
    expect(answers[0].choices.indexOf 'a').toBeGreaterThan -1
    expect(answers[0].choices.indexOf 'z').toBeGreaterThan -1
    expect(answers[0].comment?).toBe false

  it 'should process grouped-choice answers with comments', ->
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
    answers = $scope.build $scope.questions
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
        answers:
          comment: 'bar'
      }
    ]
    answers = $scope.build $scope.questions
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
        answers:
          comment: 'bar'
      }
    ]
    answers = $scope.build $scope.questions
    expect(answers?).toBe true
    expect(answers.length).toEqual 1
    expect(answers[0].question._id).toEqual 'foo'
    expect(answers[0].comment).toEqual 'bar'

  it 'should ignore not answered responses', ->
    $scope.questions = [
      {
        _id: 'q0'
        statement: 'foo'
        can_comment: yes
      },
      {
        _id: 'q1'
        statement: 'foo'
        yes_no: yes
        can_comment: yes
      },
      {
        _id: 'q2'
        statement: 'foo'
        choices: [[{title:'x'}, {title:'y'}, {title:'z'}]]
        multiple_choice: no
        can_comment: yes
      },
      {
        _id: 'q3'
        statement: 'foo'
        choices: [[{title:'x'}, {title:'y'}, {title:'z'}]]
        multiple_choice: yes
        can_comment: yes
      },
      {
        _id: 'q4'
        statement: 'foo'
        choices: [
          [{title:'x'}, {title:'y'}, {title:'z'}]
          [{title:'a'}, {title:'b'}, {title:'c'}]
        ]
        can_comment: yes
      },
    ]
    answers = $scope.build $scope.questions
    expect(answers.length).toEqual 0
