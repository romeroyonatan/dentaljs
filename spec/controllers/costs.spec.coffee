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
    controller.productCreate(body: product, res, done.fail)

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
        controller.productPricesCreate(body: [price], res, done.fail)
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
        controller.productPricesCreate(req, res, done.fail)
      # manejo de errores
      .catch done.fail
