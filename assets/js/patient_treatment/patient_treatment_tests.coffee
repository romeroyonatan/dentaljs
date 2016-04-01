describe 'dentaljs.patient_detail module', ->

  beforeEach module 'dentaljs'
  beforeEach module 'dentaljs.services'
  beforeEach module 'dentaljs.patient_detail'

  beforeEach inject (_$controller_) ->
    $controller = _$controller_

  describe 'patient_detail controller', ->

    it 'should hide pay button when a register invalid another', inject ($controller) ->
      $scope = []
      controller = $controller 'PatientListCtrl', $scope: $scope
      expect(controller).toBeDefined()
