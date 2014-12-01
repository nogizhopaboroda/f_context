#bugs
# - __slice is undefined inside executed function


@f_context ->

  module("examples")

  arguments_test_1() -> "nothing"
  arguments_test_1(A) -> "one argument: #{A}"
  arguments_test_1(A, B) -> "two arguments: #{A}, #{B}"
  arguments_test_1(A, A) -> "two arguments and it is the same: #{A}"

  #factorial
  f_fact(0) -> 1
  f_fact(N) -> N * f_fact(N - 1)


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
  f_count(List, Iterator) ->
    f_count(tl(List), Iterator + 1)


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


#test_container = {}
#@functional_context(->
#  fizbaz(5) -> 'pyat'
#, test_container)

