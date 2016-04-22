describe 'dentaljs.odontogram_edit module', ->

  beforeEach module 'dentaljs'
  beforeEach module 'dentaljs.services'
  beforeEach module 'dentaljs.odontogram_edit'

  beforeEach inject (_$controller_) ->
    $controller = _$controller_

  describe 'odontogram_edit controller', ->
