unique = (input) ->
  output = {}
  output[input[key]] = input[key] for key in [0...input.length]
  value for key, value of output


@tl = (array) -> array.slice(1)


@functional_context = (content, container = this) ->

  #private functions
  build_function = (function_body, function_arguments_names = []) ->
    concated = function_arguments_names.slice()
    concated.push(function_body)
    Function.apply(null, concated)


  #find local functions and their params

  local_functions_map = ({
    name: item.split("(").shift()
    params: item.split('(where')[0].split('(function')[0].match(/^.*\((.*)\)/)[1].split(", ")
    conditions: item.match(/^.*\((.*)\)\(where\((.*)\)\(function/)?[2].split(", ")
  } for item in content.toString().match(/(?:[a-zA-Z0-9_]+)+\(.+\)\(function/ig))

  #find uniq_functions_names
  uniq_functions_names = unique(item.name for item in local_functions_map)


  #find uniq_variables_names
  uniq_variables_names = []
  for index, item of local_functions_map
    for i, param of item.params
      if /^(?!true|false)[a-zA-Z_]([a-zA-Z0-9_]+)?$/.test(param)
        uniq_variables_names.push(param)
  uniq_variables_names = unique(uniq_variables_names)


  #make variables stubs
  make_variable = (name) ->
    fake_function = ->
      name
    fake_function.type = "variable"
    fake_function

  variables_stubs = (make_variable(x) for x in uniq_variables_names)


  #base function that local functions bind to
  functions_calls = {}
  pseudo = {}
  base_fn = (args...) ->
    functions_calls[@fn_name] or= 0
    functions_calls[@fn_name]++
    (fn) =>

      pseudo[@fn_name] or= ""

      plain_arguments = []
      variables = ""
      for argument, index in args
        if argument.type is "variable"
          variables += """
            var #{argument()} = arguments[#{index}];\n
          """
        else
          if typeof argument is 'object' and argument instanceof Array
            plain_arguments.push("JSON.stringify(arguments[#{index}]) === '#{JSON.stringify(argument)}'")
          else
            plain_arguments.push("arguments[#{index}] === #{argument}")

      plain_arguments.push("arguments.length === #{args.length}")


      duplicates = {}
      for variable in ({name: arg(), index: index} for arg, index in args when typeof arg is 'function')
        if duplicates[variable.name]?
          plain_arguments.push("arguments[#{variable.index}] === arguments[#{duplicates[variable.name]}]")
        else
          duplicates[variable.name] = variable.index



      conditions = (x for x in local_functions_map when x.name is @fn_name)[functions_calls[@fn_name] - 1].conditions
      if conditions?
        plain_arguments.push("""
          (function(#{(name for name of duplicates).join(', ')}){
            return #{conditions.join(' && ')}
          })(#{("arguments[#{index}]" for name, index of duplicates).join(', ')})
        """)

      pseudo[@fn_name] = pseudo[@fn_name] + """
        if(#{plain_arguments.join(" && ")}){
          #{variables}
          return (#{fn})()
        }\n
      """

      container[@fn_name] = build_function(pseudo[@fn_name])


  #pass stubs for local functions and variables
  build_function(
    content.toString().replace(/\n/g, ' ').replace(/function \(\) \{(.*) \}$/gmi, "$1"),
    uniq_functions_names.concat(uniq_variables_names).concat(['where'])
  ).apply(
    null,
    (base_fn.bind({ fn_name: item }) for item in uniq_functions_names)
      .concat(variables_stubs)
      .concat(-> (fn) -> fn)
  )


  true
