describe 'Costs test suite', ->
  controller = require '../../.app/controllers/costs'
  Product = require '../../.app/models/product'
  ProductPrice = require '../../.app/models/product_price'

  beforeEach (done) -> Product.remove {}, done
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
    Product.create(name: 'foo', performance_rate:1, category: 'bar')
      .then (product)->
        res =
          # el codigo que devuelve debe ser 201
          status: (status_code) ->
            expect(status_code).toBe 201
            return @
          send: ->
            # verifico que exista el precio en la bb dd
            ProductPrice
              .findOne(product: product, price: 99.99, source: 'bar')
              .then (price) ->
                expect(price).not.toBeNull()
                done()
        price = product: product, price: 99.99, source: 'bar'

        # -------------------------------------------------------------------
        # llamada a controlador
        controller.productPricesCreate(body: [price], res, done.fail)
        # -------------------------------------------------------------------

      # manejo de errores
      .catch done.fail

  it 'should create a price list', (done) ->
    Product.create(name: 'foo', performance_rate:1, category: 'bar')
      .then (product)->
        res =
          # el codigo que devuelve debe ser 201
          status: (status_code) ->
            expect(status_code).toBe 201
            return @
          send: ->
            # verifico que exista el precio en la bb dd
            ProductPrice
              .count(product: product, price: 99.99)
              .then (count) ->
                expect(count).toBe 3
                done()
        price = product: product, price: 99.99, source: 'bar'
        req = body: [price, price, price]

        # -------------------------------------------------------------------
        # llamada a controlador
        controller.productPricesCreate(req, res, done.fail)
        # -------------------------------------------------------------------

      # manejo de errores
      .catch done.fail

  it 'should get a direct costs report', (done) ->
    # creo productos
    product_list = [
      {name: 'foo', performance_rate: 1, category: 'material'},
      {name: 'bar', performance_rate: 2, category: 'material'},
      {name: 'baz', performance_rate: 10, category: 'material'},
    ]
    Product.create(product_list)
    # creo un precio para cada producto
    .then (products) ->
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
