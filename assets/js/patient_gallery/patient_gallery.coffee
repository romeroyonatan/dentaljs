angular.module('dentaljs.patient_gallery', ['ngRoute', 'ngFileUpload',
                                            'ui.bootstrap'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/gallery',
    templateUrl: '/partials/patient_gallery/patient_gallery.html'
    controller: 'PatientGalleryCtrl'
  $routeProvider.when '/patients/:slug/gallery/:folder*',
    templateUrl: '/partials/patient_gallery/patient_gallery.html'
    controller: 'PatientGalleryCtrl'
]

.controller 'PatientGalleryCtrl', [
  "$scope", "$routeParams", "$http", "$route", "$uibModal", "Upload", "Person",
  ($scope, $routeParams, $http, $route, $uibModal, Upload, Person) ->
    folder = $routeParams.folder

    # Get patient gallery
    $scope.patient = Person.get slug: $routeParams.slug, ->
      url = "/images/#{$scope.patient.slug}"
      url += "/" + folder if folder?
      $http.get(url).then (res)-> $scope.gallery = res.data

    # Upload photo to gallery
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
          $route.reload()
        , (response) ->
          # On error
          if response.status > 0
            toastr.error "Hubo un error al subir la imagen"
            console.error response
        , (evt) ->
          # While uploading is in progress
          file.progress = Math.min 100, parseInt 100.0 * evt.loaded / evt.total

    $scope.open = (photo) ->
      $uibModal.open
        templateUrl: 'partials/patient_gallery/modal_photo.html'
        controller: 'ModalPhotoCtrl',
        size: 'lg'
        resolve:
          photo: photo
]

.controller 'ModalPhotoCtrl', ['$scope', '$uibModalInstance', 'photo',
  ($scope, $uibModalInstance, photo) ->
    $scope.photo = photo
    $scope.close = -> $uibModalInstance.dismiss 'close'
]
