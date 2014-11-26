describe "f_context library", ->

  f_context ->

    f_fact(0) -> 1
    f_fact(N) -> N * f_fact(N - 1)

  it('computes factorial', ->
    expect(f_fact(5)).toBe(120)
  )
