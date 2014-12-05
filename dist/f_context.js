(function() {
  var build_function, extract_function_body, f_context, glob, keys, make_variable, unique, values,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __slice = [].slice,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  glob = typeof global !== "undefined" && global !== null ? global : this;

  unique = function(input) {
    var key, output, value, _i, _ref, _results;
    output = {};
    for (key = _i = 0, _ref = input.length; 0 <= _ref ? _i < _ref : _i > _ref; key = 0 <= _ref ? ++_i : --_i) {
      output[input[key]] = input[key];
    }
    _results = [];
    for (key in output) {
      value = output[key];
      _results.push(value);
    }
    return _results;
  };

  keys = function(obj) {
    var key, _results;
    _results = [];
    for (key in obj) {
      _results.push(key);
    }
    return _results;
  };

  values = function(obj) {
    var key, value, _results;
    _results = [];
    for (key in obj) {
      value = obj[key];
      _results.push(value);
    }
    return _results;
  };

  extract_function_body = function(fn) {
    return fn.toString().replace(/function.*\{([\s\S]+)\}$/ig, "$1");
  };

  build_function = function(function_body, function_arguments_names) {
    var concated;
    if (function_arguments_names == null) {
      function_arguments_names = [];
    }
    concated = function_arguments_names.slice();
    concated.push(function_body);
    return Function.apply(null, concated);
  };

  make_variable = function(name) {
    var fake_function;
    fake_function = function() {
      return name;
    };
    fake_function.type = "variable";
    return fake_function;
  };

  f_context = function(content, debug_container) {
    var base_fn, body, conditions, context_tree, current_module_name, fn_name, fn_parts, guards, index, item, local_functions, local_functions_map, module_body, name, param, params, part, variable, variables, x, _base, _i, _j, _k, _len, _len1, _len2, _name, _ref, _ref1;
    current_module_name = null;
    context_tree = {
      variables: [],
      functions: {}
    };
    local_functions_map = (function() {
      var _i, _len, _ref, _ref1, _ref2, _results;
      _ref = content.toString().match(/(?:[a-zA-Z0-9_]+)+\((.*)?\)\(function/ig);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        _results.push({
          name: item.split("(").shift(),
          params: ((_ref1 = item.split('(where')[0].split('(function')[0].replace(/__slice\.call\(([a-zA-Z0-9]+)\)/ig, "$1").replace(/\.concat\(([a-zA-Z0-9\[\], ]+)\)/ig, ", $1").replace(/\[([a-zA-Z0-9, ]+)\]/ig, "$1").match(/^.*\((.*)?\)/)[1]) != null ? _ref1.split(", ") : void 0) || [],
          conditions: (_ref2 = item.match(/^.*\((.*)\)\(where\((.*)\)\(function/)) != null ? _ref2[2].split(", ") : void 0
        });
      }
      return _results;
    })();
    for (_i = 0, _len = local_functions_map.length; _i < _len; _i++) {
      item = local_functions_map[_i];
      if ((_base = context_tree['functions'])[_name = item.name] == null) {
        _base[_name] = [];
      }
      context_tree['functions'][item.name].push({
        guards: item.conditions,
        params: item.params,
        variables: {},
        conditions: [],
        body: ""
      });
      _ref = item.params;
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        param = _ref[_j];
        if (/^(?!true|false)[a-zA-Z_]([a-zA-Z0-9_]+)?$/.test(param) && __indexOf.call(context_tree['variables'], param) < 0) {
          context_tree['variables'].push(param);
        }
      }
    }
    base_fn = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (function(_this) {
        return function(fn) {
          var arg, argument, destructuring_happened, duplicates, index, k, rest, restindex, subindex, variable, x, _k, _l, _len2, _len3, _len4, _m, _ref1;
          context_tree['functions'][_this.fn_name][_this.index]['body'] = extract_function_body(fn);
          for (index = _k = 0, _len2 = args.length; _k < _len2; index = ++_k) {
            argument = args[index];
            if (argument.type === "variable") {
              if (argument() !== '_') {
                context_tree['functions'][_this.fn_name][_this.index]['variables'][argument()] = "arguments[" + index + "]";
              }
            } else {
              if (typeof argument === 'object' && argument instanceof Array) {
                if (((function() {
                  var _l, _len3, _results;
                  _results = [];
                  for (_l = 0, _len3 = argument.length; _l < _len3; _l++) {
                    x = argument[_l];
                    if (typeof x === 'function') {
                      _results.push(x);
                    }
                  }
                  return _results;
                })()).length > 0) {
                  destructuring_happened = false;
                  for (subindex = _l = 0, _len3 = argument.length; _l < _len3; subindex = ++_l) {
                    k = argument[subindex];
                    if (k.destructuring) {
                      destructuring_happened = true;
                      rest = argument.length - subindex - 1;
                      context_tree['functions'][_this.fn_name][_this.index]['variables'][k()] = "arguments[" + index + "].slice(" + subindex + ", arguments[" + index + "].length - " + rest + ")";
                    } else {
                      if (destructuring_happened) {
                        restindex = argument.length - subindex;
                        context_tree['functions'][_this.fn_name][_this.index]['variables'][k()] = "arguments[" + index + "][arguments[" + index + "].length - " + restindex + "]";
                      } else {
                        context_tree['functions'][_this.fn_name][_this.index]['variables'][k()] = "arguments[" + index + "][" + subindex + "]";
                      }
                    }
                  }
                } else {
                  context_tree['functions'][_this.fn_name][_this.index]['conditions'].push("JSON.stringify(arguments[" + index + "]) === '" + (JSON.stringify(argument)) + "'");
                }
              } else if (typeof argument === 'string') {
                context_tree['functions'][_this.fn_name][_this.index]['conditions'].push("arguments[" + index + "] === '" + argument + "'");
              } else {
                context_tree['functions'][_this.fn_name][_this.index]['conditions'].push("arguments[" + index + "] === " + argument);
              }
            }
          }
          context_tree['functions'][_this.fn_name][_this.index]['conditions'].push("arguments.length === " + args.length);
          duplicates = {};
          _ref1 = (function() {
            var _len4, _n, _results;
            _results = [];
            for (index = _n = 0, _len4 = args.length; _n < _len4; index = ++_n) {
              arg = args[index];
              if (typeof arg === 'function') {
                _results.push({
                  name: arg(),
                  index: index
                });
              }
            }
            return _results;
          })();
          for (_m = 0, _len4 = _ref1.length; _m < _len4; _m++) {
            variable = _ref1[_m];
            if (variable.name !== '_') {
              if (duplicates[variable.name] != null) {
                context_tree['functions'][_this.fn_name][_this.index]['conditions'].push("arguments[" + variable.index + "] === arguments[" + duplicates[variable.name] + "]");
              } else {
                duplicates[variable.name] = variable.index;
              }
            }
          }
          return _this.index++;
        };
      })(this);
    };
    build_function(extract_function_body(content), __slice.call(keys(context_tree.functions)).concat(__slice.call(context_tree.variables), __slice.call(['where', '__slice', 'module']))).apply(null, __slice.call((function() {
        var _k, _len2, _ref1, _results;
        _ref1 = keys(context_tree.functions);
        _results = [];
        for (_k = 0, _len2 = _ref1.length; _k < _len2; _k++) {
          item = _ref1[_k];
          _results.push(base_fn.bind({
            fn_name: item,
            index: 0
          }));
        }
        return _results;
      })()).concat(__slice.call((function() {
        var _k, _len2, _ref1, _results;
        _ref1 = context_tree.variables;
        _results = [];
        for (_k = 0, _len2 = _ref1.length; _k < _len2; _k++) {
          variable = _ref1[_k];
          _results.push(make_variable(variable));
        }
        return _results;
      })()), [(function() {
        return function(fn) {
          return fn;
        };
      })], [(function() {
        var destructuring_variable;
        destructuring_variable = (function(_super) {
          __extends(destructuring_variable, _super);

          function destructuring_variable() {
            return destructuring_variable.__super__.constructor.apply(this, arguments);
          }

          return destructuring_variable;

        })(this);
        destructuring_variable.destructuring = true;
        return [destructuring_variable];
      })], [(function(module_name) {
        return current_module_name = module_name;
      })]));
    module_body = "var __slice = [].slice;\n";
    _ref1 = context_tree.functions;
    for (fn_name in _ref1) {
      fn_parts = _ref1[fn_name];
      local_functions = "";
      for (index = _k = 0, _len2 = fn_parts.length; _k < _len2; index = ++_k) {
        part = fn_parts[index];
        conditions = part.conditions, guards = part.guards, params = part.params, variables = part.variables, body = part.body;
        if (guards != null) {
          module_body += "var guard_" + fn_name + "_" + index + " = function(" + (keys(fn_parts[index].variables).join(", ")) + "){\n  return " + (guards.join(' && ')) + ";\n};";
          conditions.push("guard_" + fn_name + "_" + index + "(" + (values(fn_parts[index].variables).join(", ")) + ")");
        }
        module_body += "var " + fn_name + "_local_" + index + " = function(" + (keys(variables).join(", ")) + "){ " + body + " };\n";
        local_functions += "if(" + (conditions.join(" && ")) + "){\n";
        local_functions += "\treturn " + fn_name + "_local_" + index + "(" + (values(variables).join(", ")) + ");\n";
        local_functions += "}\n";
      }
      module_body += "var " + fn_name + " = function(){\n  " + local_functions + "\n};\n";
    }
    module_body += "return { " + (((function() {
      var _l, _len3, _ref2, _results;
      _ref2 = keys(context_tree.functions);
      _results = [];
      for (_l = 0, _len3 = _ref2.length; _l < _len3; _l++) {
        x = _ref2[_l];
        _results.push("" + x + ": " + x);
      }
      return _results;
    })()).join(',\n')) + " };";
    if (debug_container != null) {
      for (name in context_tree) {
        item = context_tree[name];
        debug_container[name] = item;
      }
    }
    if (current_module_name != null) {
      glob[current_module_name] = build_function(module_body)();
    }
    return build_function(module_body)();
  };

  f_context.version = '0.3';

  if (typeof module !== "undefined" && module !== null) {
    module.exports = f_context;
  } else {
    this.f_context = f_context;
  }

}).call(this);
