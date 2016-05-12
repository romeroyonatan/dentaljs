###
# XXX Por ahora solamente voy a soportar carpetas en un solo nivel
###
angular.module('dentaljs.patient_gallery',
  ['ngRoute', 'ngFileUpload', 'ui.bootstrap', 'angular-confirm'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/gallery',
    templateUrl: '/partials/patient_gallery/patient_gallery.html'
    controller: 'PatientGalleryCtrl'
  $routeProvider.when '/patients/:slug/gallery/:folder*',
    templateUrl: '/partials/patient_gallery/patient_gallery.html'
    controller: 'PatientGalleryCtrl'
]

.controller 'PatientGalleryCtrl', [
  "$scope", "$routeParams", "$http", "$route", "$location", "$uibModal",
  "Upload", "Person",
  ($scope, $routeParams, $http, $route, $location, $uibModal, Upload, Person)->
    foldername = $scope.foldername = $routeParams.folder

    # Get folder details
    # ----------------------------------------------------------------------
    if foldername
      $http.get "/folders/#{$routeParams.slug}/#{$routeParams.folder}"
      .then (res) ->
        $scope.folder = res.data

    # get patient
    # ----------------------------------------------------------------------
    patient = $scope.patient = Person.get slug: $routeParams.slug, ->
      url = "/images/#{$scope.patient.slug}"
      url += "/" + foldername if foldername?
      # Get patient's gallery
      $http.get(url).then (res) -> $scope.gallery = res.data
      # Get patient's folders
      $http.get("/folders/#{$routeParams.slug}").then (res) ->
        $scope.folders = res.data

    # Create a folder
    # ----------------------------------------------------------------------
    $scope.createFolder = (foldername) ->
      if not foldername
        foldername = window.prompt "Ingrese nombre de la carpeta"
      if foldername? and foldername.length > 0
        $http.post "/folders/#{$routeParams.slug}", name: foldername
        .then (res) ->
          $http.get("/folders/#{$routeParams.slug}").then (res) ->
            $scope.folders = res.data
            toastr.success "Se creó la carpeta #{foldername}"
        .catch ->
          toastr.error "No se pudo crear la carpeta #{foldername}"
          $route.reload()

    # Upload photo to gallery
    # ----------------------------------------------------------------------
    $scope.uploadPhoto = (file, errFiles) ->
      $scope.f = file
      $scope.errFile = errFiles && errFiles[0]

      # Upload photo
      if file
        if $scope.folder?
          url = "/images/#{$routeParams.slug}/#{$scope.folder._id}"
        else
          url = "/images/#{$routeParams.slug}"
        file.upload = Upload.upload
          url: url
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

    # open photo in modal window
    # ----------------------------------------------------------------------
    $scope.open = (photo) ->
      $uibModal.open
        templateUrl: 'partials/patient_gallery/modal_photo.html'
        controller: 'ModalPhotoCtrl',
        size: 'lg'
        resolve:
          photo: photo

    # remove selected photos
    # ----------------------------------------------------------------------
    $scope.removePhoto = (photos) ->
      # convert photos into array
      photos = [photos] if photos instanceof Object
      for photo in photos
        $http.delete("/images/#{photo._id}").then ->
          toastr.success "Se eliminó la foto: #{photo.path}"
          $route.reload()
        .catch ->
          toastr.error "Hubo un problema al eliminar la foto" + photo.path
          $route.reload()

    # remove selected folders
    # ----------------------------------------------------------------------
    $scope.removeFolder = (folders) ->
      # convert folders into array
      folders = [folders] if folders instanceof Object
      for folder in folders
        $http.delete("/folders/#{folder._id}").then ->
          toastr.success "Se eliminó la carpeta: #{folder.name}"
          $route.reload()
        .catch ->
          toastr.error "Hubo un problema al eliminar la foto" + photo.path
          $route.reload()

    # Choose folder where photo will be moved
    # ----------------------------------------------------------------------
    $scope.movePhoto = (photo) ->
      # open modal to select destination folder
      modal = $uibModal.open
        templateUrl: 'partials/patient_gallery/modal_folder.html'
        controller: 'ModalFolderCtrl',
        size: 'lg'
        resolve:
          folders: -> $scope.folders
      # after select folder, move photo
      modal.result.then (folder)-> $scope.move photo, folder

    # Move photo to folder
    # ----------------------------------------------------------------------
    $scope.move = (photos, folder) ->
      # Convert photo into array if it is necesary
      photos = [photos] if photos instanceof Object
      if folder is 'root'
        folder =
          _id: undefined
          name: "principal"
      # Update photo objects
      for photo in photos
        photo.folder = folder._id
        $http.put("/images/" + photo._id, photo).then ->
          toastr.success "#{photo.path} movida a la carpeta #{folder.name}"
      $route.reload()
]

# Modal: View photo
# ========================================================================
.controller 'ModalPhotoCtrl', ['$scope', '$uibModalInstance', 'photo',
  ($scope, $uibModalInstance, photo) ->
    # Set photo to show
    $scope.photo = photo
    # Dismiss modal
    $scope.close = -> $uibModalInstance.dismiss 'close'
]

# Modal: Select folder
# =========================================================================
.controller 'ModalFolderCtrl', ['$scope', '$uibModalInstance', 'folders',
  ($scope, $uibModalInstance, folders) ->
    # Set folders
    $scope.folders = folders
    # When select a item return folder
    $scope.select = (folder)-> $uibModalInstance.close folder
    # Dismiss modal
    $scope.close = -> $uibModalInstance.dismiss 'close'
]
