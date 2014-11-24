@functional_context ->

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



#test_container = {}
#@functional_context(->
#  fizbaz(5) -> 'pyat'
#, test_container)

