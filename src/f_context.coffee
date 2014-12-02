namespace = if module? then module.exports else @


unique = (input) ->
  output = {}
  output[input[key]] = input[key] for key in [0...input.length]
  value for key, value of output


f_context = (content, container = this) ->

  current_module_name = null

  #private functions
  build_function = (function_body, function_arguments_names = []) ->
    concated = function_arguments_names.slice()
    concated.push(function_body)
    Function.apply(null, concated)

  local_functions_map = ({
    name: item.split("(").shift()
    params: item.split('(where')[0].split('(function')[0].replace(/__slice\.call\(([a-zA-Z0-9]+)\)/ig, "$1").replace(/\.concat\(([a-zA-Z0-9\[\], ]+)\)/ig, ", $1").replace(/\[([a-zA-Z0-9, ]+)\]/ig, "$1").match(/^.*\((.*)?\)/)[1]?.split(", ") or []
    conditions: item.match(/^.*\((.*)\)\(where\((.*)\)\(function/)?[2].split(", ")
  } for item in content.toString().match(/(?:[a-zA-Z0-9_]+)+\((.*)?\)\(function/ig))


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

      pseudo[@fn_name] or= """
        var __slice = [].slice;
      """

      plain_arguments = []
      variables = ""
      for argument, index in args
        if argument.type is "variable"
          if argument() isnt '_'
            variables += """
              var #{argument()} = arguments[#{index}];\n
            """
        else
          if typeof argument is 'object' and argument instanceof Array
            if (x for x in argument when typeof x is 'function').length > 0
              #process destructuring
              destructuring_happened = false
              for k, subindex in argument
                if k.destructuring
                  destructuring_happened = true
                  rest = argument.length - subindex - 1
                  variables += """
                    var #{k()} = arguments[#{index}].slice(#{subindex}, arguments[#{index}].length - #{rest});\n
                  """
                else
                  if destructuring_happened
                    restindex = argument.length - subindex
                    variables += """
                      var #{k()} = arguments[#{index}][arguments[#{index}].length - #{restindex}];\n
                    """
                  else
                    variables += """
                      var #{k()} = arguments[#{index}][#{subindex}];\n
                    """
            else
              plain_arguments.push("JSON.stringify(arguments[#{index}]) === '#{JSON.stringify(argument)}'")
          else if typeof argument is 'string'
            plain_arguments.push("arguments[#{index}] === '#{argument}'")
          else
            plain_arguments.push("arguments[#{index}] === #{argument}")

      plain_arguments.push("arguments.length === #{args.length}")


      duplicates = {}
      for variable in ({name: arg(), index: index} for arg, index in args when typeof arg is 'function') when variable.name isnt '_'
        if duplicates[variable.name]?
          plain_arguments.push("arguments[#{variable.index}] === arguments[#{duplicates[variable.name]}]")
        else
          duplicates[variable.name] = variable.index


      #add destructuring variables for guards conditions
      additional_condition_variables = []
      for arg, index in args when arg instanceof Array and arg.length > 0
        destructuring_happened = false
        for x, subindex in arg
          if x.destructuring
            destructuring_happened = true
            rest = arg.length - subindex - 1
            additional_condition_variables.push({
              name: x()
              value: "arguments[#{index}].slice(#{subindex}, arguments[#{index}].length - #{rest})"
            })
          else
            if destructuring_happened
              restindex = arg.length - subindex
              additional_condition_variables.push({
                name: x()
                value: "arguments[#{index}][arguments[#{index}].length - #{restindex}]"
              })
            else
              additional_condition_variables.push({
                name: x()
                value: "arguments[#{index}][#{subindex}]"
              })
      # / add destructuring variables for guards conditions

      conditions = (x for x in local_functions_map when x.name is @fn_name)[functions_calls[@fn_name] - 1].conditions
      if conditions?
        plain_arguments.push("""
          (function(#{(name for name of duplicates).concat((item.name for item in additional_condition_variables)).join(', ')}){
            return #{conditions.join(' && ')}
          })(#{("arguments[#{index}]" for name, index of duplicates).concat((item.value for item in additional_condition_variables)).join(', ')})
        """)

      pseudo[@fn_name] = pseudo[@fn_name] + """
        if(#{plain_arguments.join(" && ")}){
          #{variables}
          return (#{fn})()
        }\n
      """

      if current_module_name? and functions_calls[@fn_name] is 1
        pseudo[@fn_name] = """
          var #{@fn_name} = #{current_module_name}['#{@fn_name}'];

        """ + pseudo[@fn_name]

      container[@fn_name] = build_function(pseudo[@fn_name])


  #pass stubs for local functions and variables
  build_function(
    content.toString().replace(/\n/g, ' ').replace(/function \(\) \{(.*) \}$/gmi, "$1"),
    uniq_functions_names
      .concat(uniq_variables_names)
      .concat(['where'])
      .concat(['__slice'])
      .concat(['module'])
  ).apply(
    null,
    (base_fn.bind({ fn_name: item }) for item in uniq_functions_names)
      .concat(variables_stubs)
      .concat(-> (fn) -> fn)
      .concat(->
        class destructuring_variable extends @
        destructuring_variable.destructuring = true
        [destructuring_variable]
      )
      .concat((module_name) ->
        current_module_name = module_name
        container = container[module_name] = {}
      )
  )


  true


namespace.f_context = f_context
namespace.f_context.version = '0.1'
