describe "Pattern matching", ->

  test_module = f_context ->

    matching_example_1("foo") -> "foo matches"
    matching_example_1("bar") -> "bar matches"
    matching_example_1(Str) -> "nothing matches"

    matching_example_1_1("foo", "bar") -> "foo and bar matches"
    matching_example_1_1("bar", "bla") -> "bar and bla matches"
    matching_example_1_1("bar", "bar") -> "bar and bar matches"
    matching_example_1_1(Str, Str2) -> "nothing matches"


  it('matches string argument', ->
    expect(test_module.matching_example_1("foo")).toBe("foo matches")
    expect(test_module.matching_example_1("bar")).toBe("bar matches")
    expect(test_module.matching_example_1("baz")).toBe("nothing matches")
  )

  it('matches multiple string argument', ->
    expect(test_module.matching_example_1_1("foo", "bar")).toBe("foo and bar matches")
    expect(test_module.matching_example_1_1("bar", "bla")).toBe("bar and bla matches")
    expect(test_module.matching_example_1_1("bar", "bar")).toBe("bar and bar matches")
    expect(test_module.matching_example_1_1("baz", "ok")).toBe("nothing matches")
  )
