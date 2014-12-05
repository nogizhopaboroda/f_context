describe "Parser", ->

  context_tree = {}

  f_context(->

    test_function(A, B, 0) -> true
    test_function(true, "ok", 0) -> true
    test_function(false, "ok", 0) -> false

    test_function2([Head, Tail...], C, 12) -> true
    test_function2([Head, Middle..., Tail], false) -> false
    test_function2(a, b, c) -> false

    testFunction3() -> true
    TestFunction4() -> true

  , context_tree)



  it('Finds functions in context', ->
    expect(
      (key for key, value of context_tree.functions)
    ).toEqual([ 'test_function', 'test_function2', 'testFunction3', 'TestFunction4' ])
  )

  it('Finds variables in context', ->
    expect(context_tree.variables).toEqual(
      [ 'A', 'B', 'Head', 'Tail', 'C', 'Middle', 'a', 'b', 'c' ]
    )
  )
