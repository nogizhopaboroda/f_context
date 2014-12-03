describe "Module", ->

  describe "Module in variable", ->

    test_module = f_context ->

      test_counter() -> test_counter(0)
      test_counter(true) -> test_counter
      test_counter(10) -> true
      test_counter(I) -> test_counter(I + 1)

      test_counter_1() -> test_counter_2()
      test_counter_2() -> true

    it('Function can run itself', ->
      expect(test_module.test_counter(0)).toBe(true)
      expect(test_module.test_counter(true)).not.toBe(undefined)
    )

    it('Function can run its own module functions as a current scope function', ->
      expect(test_module.test_counter_1()).toBe(true)
    )

  describe "Module via 'module' instruction", ->

    f_context ->

      module("test_module_2")

      test_counter() -> test_counter(0)
      test_counter(true) -> test_counter
      test_counter(10) -> true
      test_counter(I) -> test_counter(I + 1)

      test_counter_1() -> test_counter_2()
      test_counter_2() -> true

    it('Function can run itself', ->
      expect(test_module_2.test_counter(0)).toBe(true)
      expect(test_module_2.test_counter(true)).not.toBe(undefined)
    )

    it('Function can run its own module functions as a current scope function', ->
      expect(test_module_2.test_counter_1()).toBe(true)
    )
