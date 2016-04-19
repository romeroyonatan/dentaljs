xdescribe 'dentaljs.odontogram_edit module', ->

  beforeEach module 'dentaljs'
  beforeEach module 'dentaljs.services'
  beforeEach module 'dentaljs.odontogram_edit'

  beforeEach inject (_$controller_) ->
    $controller = _$controller_

  describe 'odontogram_edit controller', ->

    it 'should be load svg file', inject ($controller) ->
      $scope = {}
      controller = $controller 'OdontogramEditCtrl', $scope: $scope
      expect($(".sector").length).toBeGreaterThan(0)
