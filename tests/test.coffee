describe "Common", ->
  #delete it after divide tests
  f_context ->

    #factorial
    f_fact(0) -> 1
    f_fact(N) -> N * f_fact(N - 1)

    #array elements count
    f_count(List) ->
      f_count(List, 0)

    f_count([], Iterator) -> Iterator
    f_count([Head, List...], Iterator) ->
      f_count(List, Iterator + 1)


    #array range
    f_range(I) ->
      f_range(I, 0, [])

    f_range(I, I, Accum) -> Accum
    f_range(I, Iterator, Accum) ->
      f_range(I, Iterator + 1, Accum.concat(Iterator))


    #test guards
    f_range_guard(I) ->
      f_range_guard(I, 0, [])

    f_range_guard(I, Iterator, Accum) where(I == Iterator) -> Accum
    f_range_guard(I, Iterator, Accum) ->
      f_range_guard(I, Iterator + 1, Accum.concat(Iterator))


    #example of function all
    f_all([Head, List...], F) ->
      f_all(List, F, F(Head))

    f_all(_, _, false) -> false
    f_all([], _, _) -> true

    f_all([Head, List...], F, Memo) ->
      f_all(List, F, F(Head))


    # flatten example
    f_flatten(List) ->
      f_flatten(List, [])

    f_flatten([], Acc) -> Acc
    f_flatten([Head, List...], Acc) where(Head instanceof Array) ->
      f_flatten(List, f_flatten(Head, Acc))

    f_flatten([Head, List...], Acc) ->
      f_flatten(List, Acc.concat(Head))


  it('computes factorial', ->
    expect(f_fact(5)).toBe(120)
  )

  it('computes count', ->
    expect(f_count([0,1,2,3,4])).toBe(5)
  )

  it('computes range', ->
    expect(f_range(5)).toEqual([0,1,2,3,4])
  )

  it('computes range with guards', ->
    expect(f_range_guard(5)).toEqual([0,1,2,3,4])
  )

  it('computes function all', ->
    expect(f_all([1,2,3,4], (i) -> i > 0)).toBe(true)
    expect(f_all([1,2,3,4], (i) -> i > 1)).toBe(false)
  )

  it('computes function flatten', ->
    expect(f_flatten([1, 2, [3], [4, 5, [6, [7]]], 8])).toEqual([1,2,3,4,5,6,7,8])
  )


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



describe "Pattern matching", ->

  f_context ->

    matching_example_1("foo") -> "foo matches"
    matching_example_1("bar") -> "bar matches"
    matching_example_1(Str) -> "nothing matches"

    matching_example_1_1("foo", "bar") -> "foo and bar matches"
    matching_example_1_1("bar", "bla") -> "bar and bla matches"
    matching_example_1_1("bar", "bar") -> "bar and bar matches"
    matching_example_1_1(Str, Str2) -> "nothing matches"


  it('matches string argument', ->
    expect(matching_example_1("foo")).toBe("foo matches")
    expect(matching_example_1("bar")).toBe("bar matches")
    expect(matching_example_1("baz")).toBe("nothing matches")
  )

  it('matches multiple string argument', ->
    expect(matching_example_1_1("foo", "bar")).toBe("foo and bar matches")
    expect(matching_example_1_1("bar", "bla")).toBe("bar and bla matches")
    expect(matching_example_1_1("bar", "bar")).toBe("bar and bar matches")
    expect(matching_example_1_1("baz", "ok")).toBe("nothing matches")
  )





describe "Destructuring in arguments", ->

  f_context ->

    test_destruct_1([Head, Tail...]) -> {Head, Tail}
    test_destruct_1_1([Head, Head1, Tail...]) -> {Head, Head1, Tail}

    test_destruct_2([Head..., Last]) -> {Head, Last}
    test_destruct_2_1([Head..., Last, Last1]) -> {Head, Last, Last1}

    test_destruct_3([Head, Middle..., Last]) -> {Head, Middle, Last}
    test_destruct_3_1([Head, Head2, Middle..., Last, Last2]) -> {Head, Head2, Middle, Last, Last2}



  it('Destructs head as a first argument and tail as a rest', ->
    expect(test_destruct_1([1,2,3,4,5])).toEqual(
      Head: 1
      Tail: [2,3,4,5]
    )
  )

  it('Destructs multiple head and tail as a rest', ->
    expect(test_destruct_1_1([1,2,3,4,5])).toEqual(
      Head: 1
      Head1: 2
      Tail: [3,4,5]
    )
  )

  it('Destruct head as an array and tail as a last element', ->
    expect(test_destruct_2([1,2,3,4,5])).toEqual(
      Head: [1,2,3,4]
      Last: 5
    )
  )

  it('Destruct head as an array and multiple tail', ->
    expect(test_destruct_2_1([1,2,3,4,5])).toEqual(
      Head: [1,2,3]
      Last: 4
      Last1: 5
    )
  )

  it('Destruct head, middle and last', ->
    expect(test_destruct_3([1,2,3,4,5])).toEqual(
      Head: 1
      Middle: [2,3,4]
      Last: 5
    )
  )

  it('Destruct multiple head, middle and multiple last', ->
    expect(test_destruct_3_1([1,2,3,4,5,6,7,8])).toEqual(
      Head: 1
      Head2: 2
      Middle: [3,4,5,6]
      Last: 7
      Last2: 8
    )
  )
