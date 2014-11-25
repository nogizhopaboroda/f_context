@f_context ->

  #factorial
  f_fact(0) -> 1
  f_fact(N) -> N * f_fact(N - 1)


  #array elements count
  f_count(List) ->
    f_count(List, 0)

  f_count([], Iterator) -> Iterator
  f_count(List, Iterator) ->
    f_count(tl(List), Iterator + 1)


  #array range
  f_range(I) ->
    f_range(I, 0, [])

  f_range(I, I, Accum) -> Accum
  f_range(I, Iterator, Accum) ->
    Accum.push(Iterator)
    f_range(I, Iterator + 1, Accum)


  #test guards
  f_range_guard(I) ->
    f_range_guard(I, 0, [])

  f_range_guard(I, Iterator, Accum) where(I == Iterator) -> Accum
  f_range_guard(I, Iterator, Accum) ->
    Accum.push(Iterator)
    f_range_guard(I, Iterator + 1, Accum)


  #example of function all
  f_all(List, F) ->
    X = List[0]
    f_all(tl(List), F, F(X))

  f_all(List, F, false) -> false
  f_all([], F, Memo) -> true

  f_all(List, F, Memo) ->
    X = List[0]
    f_all(tl(List), F, F(X))


  flatten(List) ->
    flatten(List, [])

  flatten([], Acc) -> Acc
  flatten(List, Acc) where(List[0] instanceof Array) ->
    flatten(tl(List), flatten(List[0], Acc))
  flatten(List, Acc) ->
    Acc.push(List[0])
    flatten(tl(List), Acc)


#test_container = {}
#@functional_context(->
#  fizbaz(5) -> 'pyat'
#, test_container)

