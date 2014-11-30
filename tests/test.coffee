describe "Pattern matching", ->

  f_context ->

    f_fact(0) -> 1
    f_fact(N) -> N * f_fact(N - 1)

  it('computes factorial', ->
    expect(f_fact(5)).toBe(120)
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
