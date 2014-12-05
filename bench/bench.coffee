fact = f_context ->

  f_fact(0) -> 1
  f_fact(N) -> N * f_fact(N - 1)


#optimization idea
cont = ->
  abcde32423df4 = -> 1
  sdf2234gsfg52 = (N) -> N * factor(N - 1)

  factor = () ->
    if arguments[0] == 0 and arguments.length is 1
      return abcde32423df4()

    if arguments.length is 1
      return sdf2234gsfg52(arguments[0])

  {
    factor: factor
  }
container = cont()

#plain recusrion
plain_f_factorial = (n) -> !n and 1 or n * plain_f_factorial(n - 1);

#loop
plain_c_factorial = (n) ->
  result = 1
  for i in [1..n]
    result *= i
  result


suite 'Factorial', ->

  benchmark('current release', ->
    fact.f_fact(10)
  )
  benchmark('plain recursion style factorial', ->
    plain_f_factorial(10)
  )
  benchmark('plain loop style factoria', ->
    plain_c_factorial(10)
  )
  benchmark('optimization idea', ->
    container.factor(10)
  )

