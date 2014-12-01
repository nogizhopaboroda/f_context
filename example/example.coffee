@f_context ->

  module("examples")

  #factorial
  f_fact(0) -> 1
  f_fact(N) -> N * f_fact(N - 1)


  #fibonacci range
  fibonacci_range(Count) ->
    fibonacci_range(Count, 0, [])

  fibonacci_range(Count, Count, Accum) -> Accum

  fibonacci_range(Count, Iterator, Accum) where(Iterator is 0 or Iterator is 1) ->
    fibonacci_range(Count, Iterator + 1, Accum.concat(Iterator))

  fibonacci_range(Count, Iterator, [AccumHead..., A, B]) ->
    fibonacci_range(Count, Iterator + 1, AccumHead.concat(A, B).concat(A + B))


  #format price
  f_format(Str) ->
    f_format(Str, "")

  f_format(Str, Accum) where(Str.length <= 3) ->
    Str.concat(" " + Accum)

  f_format(Str, Accum) ->
    f_format(Str.slice(0, Str.length - 3), Str.slice(Str.length - 3)).concat(" " + Accum)


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


  #reduce example
  f_reduce(List, F) ->
    f_reduce(List, F, 0)

  f_reduce([], _, Memo) -> Memo

  f_reduce([X, List...], F, Memo) ->
    f_reduce(List, F, F(X, Memo))
