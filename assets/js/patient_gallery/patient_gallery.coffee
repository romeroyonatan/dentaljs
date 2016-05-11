###
# XXX Por ahora solamente voy a soportar carpetas en un solo nivel
###
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
    foldername = $scope.foldername = $routeParams.folder

    # get patient
    patient = $scope.patient = Person.get slug: $routeParams.slug, ->
      url = "/images/#{$scope.patient.slug}"
      url += "/" + foldername if foldername?
      # Get patient's gallery
      $http.get(url).then (res) -> $scope.gallery = res.data
      # Get patient's folders
      $http.get("/folders/#{$routeParams.slug}").then (res) ->
        $scope.folders = res.data

    # Create a folder
    $scope.createFolder = (foldername) ->
      if not foldername
        foldername = window.prompt "Ingrese nombre de la carpeta"
      $http.post "/folders/#{$routeParams.slug}", name: foldername
      .then (res) ->
        $http.get("/folders/#{$routeParams.slug}").then (res) ->
          $scope.folders = res.data

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
