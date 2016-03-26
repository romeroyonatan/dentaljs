describe 'dentaljs.patient_list module', ->

  beforeEach module 'dentaljs'
  beforeEach module 'dentaljs.services'
  beforeEach module 'dentaljs.patient_list'

  beforeEach inject (_$controller_) ->
    $controller = _$controller_

  describe 'patient_list controller', ->

    it 'should show a list of patients', inject ($controller) ->
      $scope = {}
      controller = $controller 'PatientListCtrl', $scope: $scope
      expect(controller).toBeDefined()
