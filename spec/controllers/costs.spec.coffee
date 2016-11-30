describe 'Costs test suite', ->
  controller = require '../../.app/controllers/costs'
  Product = require '../../.app/models/product'
  ProductPrice = require '../../.app/models/product_price'
  products = []
  prices = []

  beforeEach (done) ->
    Product.remove({}).then ->
      # ------------------------------------------------------------------------
      # creo productos
      product_list = [
        {name: 'foo', performance_rate: 1, category: 'material'},
        {name: 'bar', performance_rate: 2, category: 'material'},
        {name: 'baz', performance_rate: 10, category: 'material'},
      ]
      Product.create(product_list).then (_products) -> products = _products
      # ----------------------------------------------------------------------
      # creo un precio para cada producto
      .then ->
        price_list = [
          {product: products[0], price: 99.99, source: 'ebay'}
          {product: products[1], price: 44.44, source: 'alamaula'}
          {product: products[2], price: 100, source: 'mercadolibre'}
        ]
        ProductPrice.create(price_list).then (_prices) -> prices = _prices
      .then done
      .catch done.fail

  afterEach (done) -> Product.remove {}, done

  it 'should create new product', (done) ->
    res =
      # el codigo que devuelve debe ser 201
      status: (status_code) ->
        expect(status_code).toBe 201
        return @
      send: ->
        # verifico que exista el producto en la bb dd
        Product
          .findOne(name: 'foo', performance_rate: 1, category: 'bar')
          .then (product) ->
            expect(product).not.toBeNull()
            done()
    product = name: 'foo', performance_rate: 1, category: 'bar'

    # -------------------------------------------------------------------
    # llamada a controlador
    controller.productCreate(body: product, res, done.fail)
    # -------------------------------------------------------------------

  it 'should create one new price', (done) ->
    res =
      # el codigo que devuelve debe ser 201
      status: (status_code) ->
        expect(status_code).toBe 201
        return @
      send: ->
        # verifico que exista el precio en la bb dd
        ProductPrice
          .findOne(product: products[0], price: 89.99, source: 'bar')
          .then (price) ->
            expect(price).not.toBeNull()
            done()

    # -------------------------------------------------------------------
    # llamada a controlador
    price = product: products[0], price: 89.99, source: 'bar'
    controller.productPricesCreate(body: [price], res, done.fail)
    # -------------------------------------------------------------------

  it 'should create a price list', (done) ->
    res =
      # el codigo que devuelve debe ser 201
      status: (status_code) ->
        expect(status_code).toBe 201
        return @
      send: ->
        # verifico que exista el precio recien creado
        promises = for product in products
          ProductPrice.findOne(product: product, price: 10.99)
                      .then (product) -> expect(product.price).toBe 10.99
        Promise.all(promises).then done

    # -------------------------------------------------------------------
    # llamada a controlador
    prices = [
      {product: products[0], price: 10.99, source: 'bar'},
      {product: products[1], price: 10.99, source: 'bar'},
      {product: products[2], price: 10.99, source: 'bar'},
    ]
    controller.productPricesCreate(body: prices, res, done.fail)
    # -------------------------------------------------------------------

  it 'should get a direct costs report', (done) ->
    # creo un precio para cada producto
    price_list = [
      {product: products[0], price: 99.99}
      {product: products[1], price: 44.44}
      {product: products[2], price: 100}
    ]
    ProductPrice.create(price_list)
    # verifico que el reporte sea correcto
    .then (prices) ->
      res = send: (list) ->
        for i in [0..2]
          # busco cada producto declarado en product list en la respuesta
          # del controller
          search = list.filter (p) -> p.name == products[i].name
          product = search[0]
          # verifico que id de producto
          expect(product._id).toEqual products[i]._id
          # verifico performance rate
          expect(product.performance_rate).toEqual(
            products[i].performance_rate
          )
          # verifico precio
          expect(product.price).toEqual(prices[i].price)
          # verifico precio de uso
          expect(product.use_price).toEqual(
            prices[i].price / products[i].performance_rate
          )
        # todo ok
        done()

      # -------------------------------------------------------------------
      # llamada a controlador
      controller.directCostReport({}, res, done.fail)
      # -------------------------------------------------------------------
    # control de errores
    .catch done.fail

  it 'should get a direct costs report using multiple prices', (done) ->
    # esta lista de precios es la que vale porque es la ultima
    price_list = [
      {product: products[0], price: 10}
      {product: products[1], price: 20}
      {product: products[2], price: 30}
    ]
    ProductPrice.create(price_list)
    # verifico que el reporte sea correcto
    .then (prices2) ->
      res = send: (list) ->
        for i in [0..2]
          # busco cada producto declarado en product list en la respuesta
          # del controller
          search = list.filter (p) -> p.name == products[i].name
          product = search[0]
          # verifico precio
          expect(product.price).toEqual(prices2[i].price)
        # todo ok
        done()

      # -------------------------------------------------------------------
      # llamada a controlador
      controller.directCostReport({}, res, done.fail)
      # -------------------------------------------------------------------
    # control de errores
    .catch done.fail

  it 'should get a direct costs without prices', (done) ->
    ProductPrice.remove {}
    .then () ->
      res = send: (list) ->
        for i in [0..2]
          # busco cada producto declarado en product list en la respuesta
          # del controller
          search = list.filter (p) -> p.name == products[i].name
          product = search[0]
          # verifico que el precio sea null
          expect(product.price).not.toBeDefined()
          # verifico que la tasa de rendimiento sea null
          expect(product.use_price).not.toBeDefined()
        # todo ok
        done()

      # -------------------------------------------------------------------
      # llamada a controlador
      controller.directCostReport({}, res, done.fail)
      # -------------------------------------------------------------------
    # control de errores
    .catch done.fail

  it 'should retrieve product details', (done) ->
    res =
      send: (product) ->
        expect(product.name).toEqual products[0].name
        expect(product.performance_rate).toEqual products[0].performance_rate
        expect(product.prices[0].price).toEqual prices[0].price
        expect(product.prices[0].source).toEqual prices[0].source
        done()

    # -------------------------------------------------------------------
    # llamada a controlador
    req = params: id: products[0]._id
    controller.productDetail(req, res, done.fail)
    # -------------------------------------------------------------------

  it 'should return 404 when product does not exists', (done) ->
    next = (err) ->
      expect(err.status).toBe 404
      done()
    # -------------------------------------------------------------------
    # llamada a controlador
    req = params: id: "_____inexistent_id______"
    controller.productDetail(req, {}, next)
    # -------------------------------------------------------------------

  it 'should update a product', (done) ->
    res =
      send: (product) ->
        Product.findById(product._id).then (product) ->
          expect(product.name).toEqual "foo-bar"
          expect(product.performance_rate).toEqual 99
          done()
        .catch done.fail

    # -------------------------------------------------------------------
    # llamada a controlador
    req =
      params: id: products[0]._id
      body:
        name: 'foo-bar'
        performance_rate: 99
    controller.productUpdate(req, res, done.fail)
    # -------------------------------------------------------------------

  it 'should delete a product', (done) ->
    res =
      status: (status_code) ->
        expect(status_code).toBe 204
        return this
      end: ->
        Product.findById(products[0]._id).then (product) ->
          expect(product).toBeNull()
          done()
        .catch done.fail

    # -------------------------------------------------------------------
    # llamada a controlador
    req = params: id: products[0]._id
    controller.productDelete(req, res, done.fail)
    # -------------------------------------------------------------------
