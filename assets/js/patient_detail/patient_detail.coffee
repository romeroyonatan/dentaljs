angular.module('dentaljs.patient_detail', ['ngRoute', 'ngFileUpload'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug',
    templateUrl: '/partials/patient_detail/patient_detail.html'
    controller: 'PatientDetailCtrl'
]

.controller 'PatientDetailCtrl', [
  "$scope", "$routeParams", "$location", "Upload", "Person", "Accounting",
  ($scope, $routeParams, $location, Upload, Person, Accounting) ->
    $scope.patient = Person.get slug: $routeParams.slug

    $scope.uploadPhoto = (file, errFiles) ->
      $scope.f = file
      $scope.errFile = errFiles && errFiles[0]

      # Upload photo
      if file
        file.upload = Upload.upload
          url: "/images/#{$routeParams.slug}"
          method: 'POST'
          file: file

        file.upload.then (response) ->
          # On success
          toastr.success "Imagen subida con éxito"
          file.result = response.data
          $location.path "/patients/#{$scope.patient.slug}/gallery"
        , (response) ->
          # On error
          if response.status > 0
            toastr.error "Hubo un error al subir la imagen"
            console.error response
        , (evt) ->
          # While uploading is in progress
          file.progress = Math.min 100, parseInt 100.0 * evt.loaded / evt.total
]
