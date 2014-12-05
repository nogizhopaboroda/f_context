glob = if global? then global else @

#lists tools
unique = (input) ->
  output = {}
  output[input[key]] = input[key] for key in [0...input.length]
  value for key, value of output

keys = (obj) -> (key for key of obj)
values = (obj) -> (value for key, value of obj)


#functions tools
extract_function_body = (fn) ->
  fn.toString().replace(/function.*\{([\s\S]+)\}$/ig, "$1")

build_function = (function_body, function_arguments_names = []) ->
  concated = function_arguments_names.slice()
  concated.push(function_body)
  Function.apply(null, concated)

make_variable = (name) ->
  fake_function = ->
    name
  fake_function.type = "variable"
  fake_function



f_context = (content, debug_container) ->

  current_module_name = null

  context_tree = {
    variables: []
    functions: {}
  }

  local_functions_map = ({
    name: item.split("(").shift()
    params: item.split('(where')[0]
      .split('(function')[0]
      .replace(/__slice\.call\(([a-zA-Z0-9]+)\)/ig, "$1")
      .replace(/\.concat\(([a-zA-Z0-9\[\], ]+)\)/ig, ", $1")
      .replace(/\[([a-zA-Z0-9, ]+)\]/ig, "$1")
      .match(/^.*\((.*)?\)/)[1]?.split(", ") or []
    conditions: item
                .match(/^.*\((.*)\)\(where\((.*)\)\(function/)?[2].split(", ")
  } for item in \
      content.toString().match(/(?:[a-zA-Z0-9_]+)+\((.*)?\)\(function/ig))


  #build context tree
  for item in local_functions_map
    context_tree['functions'][item.name] ?= []
    context_tree['functions'][item.name].push(
      guards: item.conditions
      params: item.params
      variables: {}
      conditions: []
      body: ""
    )

    context_tree['variables'].push(param) \
      for param in item.params \
      when /^(?!true|false)[a-zA-Z_]([a-zA-Z0-9_]+)?$/.test(param) \
        and param not in context_tree['variables']



  #base function that local functions bind to
  base_fn = (args...) ->

    (fn) =>

      context_tree['functions'][@fn_name][@index]['body'] = \
        extract_function_body(fn)

      for argument, index in args
        if argument.type is "variable"
          if argument() isnt '_'
            context_tree['functions'][@fn_name]\
              [@index]['variables'][argument()] = "arguments[#{index}]"

        else
          if typeof argument is 'object' and argument instanceof Array
            if (x for x in argument when typeof x is 'function').length > 0
              #process destructuring
              destructuring_happened = false
              for k, subindex in argument
                if k.destructuring
                  destructuring_happened = true
                  rest = argument.length - subindex - 1
                  context_tree['functions'][@fn_name]\
                    [@index]['variables'][k()] = \
                      "arguments[#{index}].slice(#{subindex}, \
                       arguments[#{index}].length - #{rest})"
                else
                  if destructuring_happened
                    restindex = argument.length - subindex
                    context_tree['functions'][@fn_name]\
                      [@index]['variables'][k()] = \
                        "arguments[#{index}]\
                         [arguments[#{index}].length - #{restindex}]"
                  else
                    context_tree['functions'][@fn_name]\
                    [@index]['variables'][k()] = \
                      "arguments[#{index}][#{subindex}]"
            else
              context_tree['functions'][@fn_name]\
                [@index]['conditions'].push(\
                  "JSON.stringify(arguments[#{index}]) === \
                  '#{JSON.stringify(argument)}'"\
                )

          else if typeof argument is 'string'
            context_tree['functions'][@fn_name]\
              [@index]['conditions'].push(\
                "arguments[#{index}] === '#{argument}'"\
              )
          else
            context_tree['functions'][@fn_name][@index]['conditions'].push("arguments[#{index}] === #{argument}")

      context_tree['functions'][@fn_name][@index]['conditions'].push("arguments.length === #{args.length}")


      duplicates = {}
      for variable in ({name: arg(), index: index} for arg, index in args when typeof arg is 'function') when variable.name isnt '_'
        if duplicates[variable.name]?
          context_tree['functions'][@fn_name][@index]['conditions'].push("arguments[#{variable.index}] === arguments[#{duplicates[variable.name]}]")
        else
          duplicates[variable.name] = variable.index


      @index++


  #pass stubs for local functions and variables
  build_function(
    extract_function_body(content),
    [
      keys(context_tree.functions)... ,
      context_tree.variables... ,
      ['where', '__slice', 'module']...
    ]
  ).apply(
    null,
    [
      (base_fn.bind({ fn_name: item, index: 0 }) for item in keys(context_tree.functions))... ,
      (make_variable(variable) for variable in context_tree.variables)... ,
      (-> (fn) -> fn),
      (->
        class destructuring_variable extends @
        destructuring_variable.destructuring = true
        [destructuring_variable]
      ),
      ((module_name) ->
        current_module_name = module_name
      )
    ]
  )


  module_body = "var __slice = [].slice;\n"

  for fn_name, fn_parts of context_tree.functions

    local_functions = ""

    for part, index in fn_parts

      {conditions, guards, params, variables, body} = part

      if guards?
        module_body += """
          var guard_#{fn_name}_#{index} = function(#{keys(fn_parts[index].variables).join(", ")}){
            return #{guards.join(' && ')};
          };
        """

        conditions.push("guard_#{fn_name}_#{index}(#{values(fn_parts[index].variables).join(", ")})")

      module_body += "var #{fn_name}_local_#{index} = function(#{keys(variables).join(", ")}){ #{body} };\n"

      local_functions += "if(#{conditions.join(" && ")}){\n"
      local_functions += "\treturn #{fn_name}_local_#{index}(#{values(variables).join(", ")});\n"
      local_functions += "}\n"


    module_body += """
      var #{fn_name} = function(){
        #{local_functions}
      };\n
    """


  module_body += """
    return { #{("#{x}: #{x}" for x in keys(context_tree.functions)).join(',\n')} };
  """


  if debug_container?
    for name, item of context_tree
      debug_container[name] = item


  if current_module_name?
    glob[current_module_name] = build_function(module_body)()


  build_function(module_body)()



f_context.version = '0.3'


if module?
  module.exports = f_context
else
  @f_context = f_context
