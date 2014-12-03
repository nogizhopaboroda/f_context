fact = f_context ->

  f_fact(0) -> 1
  f_fact(N) -> N * f_fact(N - 1)


suite 'Factorial', ->

  benchmark('fact', ->
    fact.f_fact(10)
  )
