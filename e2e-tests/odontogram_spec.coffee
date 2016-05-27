describe 'Odontogram widget', ->

  pieces = element.all By.css '.piece'
  # piece 18
  piece18 = pieces.get 7
  # sector 0
  sector = piece18.all(By.css '.sector').get(4)
  # first fix
  btn_fix = element.all(By.css '.btn-fix').first()
  # first desease
  btn_disease = element.all(By.css '.btn-disease').first()
  # clear button
  btn_clear = element By.xpath '/html/body/div/div[1]/div[3]/div[3]/button'
  # remove button
  btn_remove = piece18.element By.css(".btn-disease")

# TODO Ver como mockear las respuestas del server
  beforeEach ->
    browser.get '#/patients/juan-perex/odontograms/new'

  it 'should have an svg', ->
    expect(element(By.css 'svg').isPresent()).toBe true

  it 'should can select a sector', ->
    # select piece
    selected = piece18.element By.css '.sector.selected'
    expect(selected.isPresent()).toBe false
    sector.click()
    selected = piece18.element By.css '.sector.selected'
    expect(selected.isPresent()).toBe true

  it 'should can mark sector as fixed', ->
    sector.click()
    btn_fix.click()
    # sector should be marked
    fix = element By.css '.sector.fix'
    expect(fix.isPresent()).toBe true
    # should not be a selected sector
    selected = element By.css '.sector.selected'
    expect(selected.isPresent()).toBe false

  it 'should can mark sector as diseased', ->
    sector.click()
    btn_disease.click()
    # sector should be marked
    disease = element By.css '.sector.disease'
    expect(disease.isPresent()).toBe true
    # should not be a selected sector
    selected = element By.css '.sector.selected'
    expect(selected.isPresent()).toBe false

  it 'should can clear a sector', ->
    sector.click()
    btn_disease.click()
    # sector should be marked
    disease = element By.css '.sector.disease'
    expect(disease.isPresent()).toBe true
    # clear the sector
    sector.click()
    btn_clear.click()
    expect(sector.getAttribute('class')).toBe 'sector'

  it 'should mark teeth as removed', ->
    # the piece must has a  hide strikethough
    strikethough = piece18.element By.css ".removed"
    expect(strikethough.getCssValue('display')).toBe 'none'
    # click on piece's remove button
    btn_remove.click()
    # clear the sector
    expect(strikethough.getCssValue('display')).toBe 'inline'

  it "should quit remove's mark teeth", ->
    # the piece must has a  hide strikethough
    strikethough = piece18.element By.css ".removed"
    expect(strikethough.getCssValue('display')).toBe 'none'
    # click on piece's remove button twice
    btn_remove.click()
    expect(strikethough.getCssValue('display')).toBe 'inline'
    btn_remove.click()
    # clear the sector
    expect(strikethough.getCssValue('display')).toBe 'none'

  it "should mark multiple sector as fixed", ->
    # click all sectors of third quadrant
    quadrant3 = element.all(By.css '.quadrant').get 2
    sectors = quadrant3.all By.css '.sector'
    sectors.each (elem) ->
      elem.click()
    .then ->
      btn_fix.click()
      fixed = element.all By.css '.sector.fix'
      expect(fixed.count()).toEqual 40 # 32 pieces * 5 sectors
      # should not be sectors selected
      selected = element.all By.css '.sector.selected'
      expect(selected.count()).toEqual 0

  it "should mark multiple sector as disease", ->
    # click all sectors of second quadrant
    quadrant2 = element.all(By.css '.quadrant').get 1
    sectors = quadrant2.all By.css '.sector'
    sectors.each (elem) ->
      elem.click()
    .then ->
      btn_disease.click()
      fixed = element.all By.css '.sector.disease'
      expect(fixed.count()).toEqual 40 # 8 pieces * 5 sectors
      # should not be sectors selected
      selected = element.all By.css '.sector.selected'
      expect(selected.count()).toEqual 0

  it "should clear multiple sector", ->
    # click all sectors of fourth quadrant
    quadrant4 = element.all(By.css '.quadrant').get 3
    sectors = quadrant4.all By.css '.sector'
    sectors.each (elem) ->
      elem.click()
    .then ->
      # mark sectors as disease
      btn_disease.click()
      selected = element.all By.css '.sector.disease'
      expect(selected.count()).toEqual 40
      # select sectors again to clear
      sectors.each (elem) ->
        elem.click()
      .then ->
        btn_clear.click()
        # should not be sectors diseased
        selected = element.all By.css '.sector.disease'
        expect(selected.count()).toEqual 0

  it "should remove multiple teeths", ->
    # click all sectors of fourth quadrant
    quadrant1 = element.all(By.css '.quadrant').get 0
    buttons = quadrant1.all By.tagName 'button'
    buttons.each (elem) ->
      elem.click()
    .then ->
      quadrant1.all(By.css '.removed').each (strikethough) ->
        expect(strikethough.getCssValue('display')).toBe 'inline'

  it "should clear remove mark multiple times", ->
    # click all sectors of fourth quadrant
    quadrant1 = element.all(By.css '.quadrant').get 0
    buttons = quadrant1.all By.tagName 'button'
    buttons.each (elem) ->
      elem.click()
    .then ->
      quadrant1.all(By.css '.removed').each (strikethough) ->
        expect(strikethough.getCssValue('display')).toBe 'inline'
      buttons.each (elem) ->
        elem.click()
      quadrant1.all(By.css '.removed').each (strikethough) ->
        expect(strikethough.getCssValue('display')).toBe 'none'

  it "mix fixes and diseases", ->
    # click all sectors of second quadrant
    quadrant1 = element.all(By.css '.quadrant').get 0
    quadrant3 = element.all(By.css '.quadrant').get 2
    fixes = quadrant1.all By.css '.sector'
    diseases = quadrant3.all By.css '.sector'
    fixes.each (elem) ->
      elem.click()
    .then ->
      btn_fix.click()
      diseases.each (elem) ->
        elem.click()
      .then ->
        btn_disease.click()
        fixed = element.all By.css '.sector.fix'
        expect(fixed.count()).toEqual 40 # 8 pieces * 5 sectors
        diseased = element.all By.css '.sector.disease'
        expect(fixed.count()).toEqual 40 # 8 pieces * 5 sectors

  it "multiple fixes click even", ->
    for i in [0...6]
      sector.click()
      btn_fix.click()
    # sector should be marked
    fix = element By.css '.sector.fix'
    expect(fix.isPresent()).toBe false
    # should not be a selected sector
    selected = element By.css '.sector.selected'
    expect(selected.isPresent()).toBe false

  it "multiple fixes click odd", ->
    for i in [0...5]
      sector.click()
      btn_fix.click()
    # sector should be marked
    fix = element By.css '.sector.fix'
    expect(fix.isPresent()).toBe true
    # should not be a selected sector
    selected = element By.css '.sector.selected'
    expect(selected.isPresent()).toBe false
