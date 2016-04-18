angular.module('dentaljs.odontogram_edit', ['ngRoute'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/odontograms/edit',
    templateUrl:
      '/partials/odontogram_edit/odontogram_edit.html'
    controller: 'OdontogramEditCtrl'
]

.controller 'OdontogramEditCtrl', [
  "$scope", "$routeParams", ($scope, $routeParams) ->
    $scope.diseases = [
      {code: "A", description: "Enfermedad A"},
      {code: "B", description: "Enfermedad B"},
      {code: "C", description: "Enfermedad C"},
      {code: "D", description: "Enfermedad D"},
    ]
    $scope.fixes = [
      {code: "X", description: "Arreglo X"},
      {code: "Y", description: "Arreglo Y"},
      {code: "Z", description: "Arreglo Z"},
    ]

    # when user clicks over a fix button, mark all selected sectors as fixed
    $scope.setFix = (fix) ->
      console.log fix
      $(".selected").removeClass()
                    .addClass 'sector fix'
                    .attr 'title', fix.description
      true

    # when user clicks over a disease button, mark all selected sectors as
    # diseased
    $scope.setDisease = (disease) ->
      console.log disease
      $(".selected").removeClass()
                    .addClass 'sector disease'
                    .attr 'title', disease.description
      true

    # when user clicks over a removed button, mark all teeths selected as
    # removed
    $scope.setRemoved = ->
      $('.selected').nextAll('.removed').toggle()
      $('.selected').removeClass('selected')
      true

    # when user clicks over a clean button, clean selected sectors to default
    # value. If teeth is marked as removed, the mark will be clean
    $scope.clean = ->
      $('.selected').nextAll('.removed').hide()
      $(".selected").removeClass()
                    .addClass('sector')
                    .attr('title', '')
      true

    # Bindings for teeth's sector click
    $(".sector").on "click touchstart", (e) ->
      e.preventDefault()
      $(@).toggleClass("selected")
]
