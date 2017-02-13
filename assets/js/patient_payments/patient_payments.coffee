angular.module('dentaljs.patient_payments',
  ['ngRoute', 'ui.bootstrap', 'angular-confirm'])

.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/patients/:slug/payments',
    templateUrl: '/partials/patient_payments/patient_payments.html'
    controller: 'PatientPaymentsCtrl'
  $routeProvider.when '/patients/:slug/payments/:category',
    templateUrl: '/partials/patient_payments/patient_payments.html'
    controller: 'PatientPaymentsCtrl'
]

.controller 'PatientPaymentsCtrl', ["$scope", "$routeParams", "$route",
  "$http", "$uibModal", "Person", "Accounting",
  ($scope, $routeParams, $route, $http, $uibModal, Person, Accounting) ->
    # initialize scope vars
    $scope.accounting = []
    $scope.balance = 0
    $scope.categories = []
    $scope.category = null

    # Get patient's payments
    # ------------------------------------------------------------------------
    # get patient and its accounting
    $scope.patient = Person.get slug: $routeParams.slug, ->
      # get list of categories
      $http.get("/accounting/categories").then (res) ->
        for cat in res.data
          # get active category
          $scope.category = cat if cat.slug is $routeParams.category
          # get category details
          $http.get("/accounting/categories/" + cat._id).then (res) ->
            $scope.categories.push res.data

        # get payments list
        $scope.accounting = Accounting.query
          person: $scope.patient._id
          category: $scope.category._id if $scope.category?
          , ->
            $http.get("/accounting/balance/" + $scope.patient._id).then (res) ->
              $scope.balance = res.data.balance
              $scope.size = res.data.size # payments' lenght

    #  add()
    # ------------------------------------------------------------------------
    # add new accounting to list and add mounts to balance
    add = (account)->
      $scope.accounting.push account
      # modify balance
      $scope.balance -= account.debit if account.debit?
      $scope.balance += account.assets if account.assets?
      # clean scope's account
      $scope.account = {}

    #  subtract()
    # ------------------------------------------------------------------------
    # remove accounting from list and subtract from balance
    subtract = (account)->
      $scope.accounting = (
        a for a in $scope.accounting when a._id isnt account._id
      )
      $scope.balance += account.debit if account.debit?
      $scope.balance -= account.assets if account.assets?

    #  new()
    # ------------------------------------------------------------------------
    # create new account
    $scope.new = (account) ->
      account.person = $scope.patient._id
      account.category = $scope.category
      accounting = new Accounting account
      accounting.$save().then ->
        add(accounting)
        toastr.success "Registro creado con éxito"
        # Send current accounting via mail
        $scope.send_mail()


    #  delete()
    # ------------------------------------------------------------------------
    # remove accounting
    $scope.delete = (account) ->
      account = new Accounting account if account not instanceof Accounting
      account.$delete().then ->
        $route.reload()
        toastr.success "Registro eliminado con éxito"

    #  update()
    # ------------------------------------------------------------------------
    # edit existing accounting
    $scope.update = (account) ->
      account.person = $scope.patient._id
      resource = new Accounting account
      resource.$update().then ->
        # Reload page
        $route.reload()
        toastr.success "Registro actualizado con éxito"

    #  showEdit()
    # ------------------------------------------------------------------------
    # shows a modal with update's form
    $scope.showEdit = (account) ->
      $uibModal.open
        templateUrl: 'partials/patient_payments/modal_edit.html'
        controller: 'ModalUpdateCtrl',
        resolve:
          account: account
      .result.then (account) -> $scope.update account

    #  showDependant()
    # ------------------------------------------------------------------------
    # shows a modal to create a dependant account
    $scope.showDependant = (account) ->
      $uibModal.open
        templateUrl: 'partials/patient_payments/modal_dependant.html'
        controller: 'ModalDependantCtrl'
        resolve: parent: account
      .result.then (account) ->
        $scope.new account
        $route.reload()

    #  print()
    # ------------------------------------------------------------------------
    # show print prompt
    $scope.print = -> window.print()

    #  send_mail()
    # ------------------------------------------------------------------------
    # send balance via email
    $scope.send_mail = ->
      $scope.sending_mail = true
      $http.post("/emails/current_account/" + $scope.patient._id)
      .then (res) ->
        toastr.success '✉ El correo se ha enviado correctamente'
        $scope.sending_mail = false
      .catch ->
        toastr.error "No se pudo enviar el email. Intente de nuevo mas tarde"
        $scope.sending_mail = false
]

.controller 'ModalUpdateCtrl', ['$scope', '$uibModalInstance', '$http',
  'account', ($scope, $uibModalInstance, $http, account) ->
    $scope.account = account
    # convert number to string
    if $scope.account.piece?
      $scope.account.piece = $scope.account.piece.toString()
    $http.get("/accounting/categories").then (res) ->
      $scope.categories = res.data
    $scope.ok = -> $uibModalInstance.close $scope.account
    $scope.cancel = -> $uibModalInstance.dismiss 'cancel'
]

.controller 'ModalDependantCtrl', ['$scope', '$uibModalInstance', 'parent',
  ($scope, $uibModalInstance, parent) ->
    $scope.account =
      parent: parent
    $scope.ok = -> $uibModalInstance.close $scope.account
    $scope.cancel = -> $uibModalInstance.dismiss 'cancel'
]
