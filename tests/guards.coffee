describe "Guards", ->

  f_context ->

    test_guards_1(I) where(I > 10) -> true
    test_guards_1(I) where(I < 10) -> false
    test_guards_1(I) -> I

    test_guards_2(I, K) where(I > 10 and K < 20) -> true
    test_guards_2(I, K) where(I < 10 and K > 20) -> false
    test_guards_2(I, K) -> {I, K}



  it('Handle single condition in guard', ->
    expect(test_guards_1(20)).toBe(true)
    expect(test_guards_1(5)).toBe(false)
    expect(test_guards_1(10)).toBe(10)
  )

  it('Handle multiple conditions in guard', ->
    expect(test_guards_2(20, 10)).toBe(true)
    expect(test_guards_2(5, 30)).toBe(false)
    expect(test_guards_2(10, 20)).toEqual(
      I: 10
      K: 20
    )
  )
