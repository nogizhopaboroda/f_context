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
