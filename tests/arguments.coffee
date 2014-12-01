describe "Arguments", ->

  f_context ->

    arguments_test_1() -> "nothing"
    arguments_test_1(A) -> "one argument: #{A}"
    arguments_test_1(A, A) -> "two arguments and it is the same: #{A}"
    arguments_test_1(A, B) -> "two arguments: #{A}, #{B}"


  it('matches string argument', ->
    expect(arguments_test_1()).toBe("nothing")
    expect(arguments_test_1("ok")).toBe("one argument: ok")
    expect(arguments_test_1("ok", "not ok")).toBe("two arguments: ok, not ok")
    expect(arguments_test_1("ok", "ok")).toBe("two arguments and it is the same: ok")
  )

