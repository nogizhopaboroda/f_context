(function() {
  var unique,
    __slice = [].slice,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

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

  this.tl = function(array) {
    return array.slice(1);
  };

  this.f_context = function(content, container) {
    var base_fn, build_function, functions_calls, i, index, item, local_functions_map, make_variable, param, pseudo, uniq_functions_names, uniq_variables_names, variables_stubs, x, _ref;
    if (container == null) {
      container = this;
    }
    build_function = function(function_body, function_arguments_names) {
      var concated;
      if (function_arguments_names == null) {
        function_arguments_names = [];
      }
      concated = function_arguments_names.slice();
      concated.push(function_body);
      return Function.apply(null, concated);
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
    uniq_functions_names = unique((function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = local_functions_map.length; _i < _len; _i++) {
        item = local_functions_map[_i];
        _results.push(item.name);
      }
      return _results;
    })());
    uniq_variables_names = [];
    for (index in local_functions_map) {
      item = local_functions_map[index];
      _ref = item.params;
      for (i in _ref) {
        param = _ref[i];
        if (/^(?!true|false)[a-zA-Z_]([a-zA-Z0-9_]+)?$/.test(param)) {
          uniq_variables_names.push(param);
        }
      }
    }
    uniq_variables_names = unique(uniq_variables_names);
    make_variable = function(name) {
      var fake_function;
      fake_function = function() {
        return name;
      };
      fake_function.type = "variable";
      return fake_function;
    };
    variables_stubs = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = uniq_variables_names.length; _i < _len; _i++) {
        x = uniq_variables_names[_i];
        _results.push(make_variable(x));
      }
      return _results;
    })();
    functions_calls = {};
    pseudo = {};
    base_fn = function() {
      var args, _name;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      functions_calls[_name = this.fn_name] || (functions_calls[_name] = 0);
      functions_calls[this.fn_name]++;
      return (function(_this) {
        return function(fn) {
          var additional_condition_variables, arg, argument, conditions, destructuring_happened, duplicates, k, name, plain_arguments, rest, restindex, subindex, variable, variables, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _m, _name1, _ref1;
          pseudo[_name1 = _this.fn_name] || (pseudo[_name1] = "");
          plain_arguments = [];
          variables = "";
          for (index = _i = 0, _len = args.length; _i < _len; index = ++_i) {
            argument = args[index];
            if (argument.type === "variable") {
              if (argument() !== '_') {
                variables += "var " + (argument()) + " = arguments[" + index + "];\n";
              }
            } else {
              if (typeof argument === 'object' && argument instanceof Array) {
                if (((function() {
                  var _j, _len1, _results;
                  _results = [];
                  for (_j = 0, _len1 = argument.length; _j < _len1; _j++) {
                    x = argument[_j];
                    if (typeof x === 'function') {
                      _results.push(x);
                    }
                  }
                  return _results;
                })()).length > 0) {
                  destructuring_happened = false;
                  for (subindex = _j = 0, _len1 = argument.length; _j < _len1; subindex = ++_j) {
                    k = argument[subindex];
                    if (k.destructuring) {
                      destructuring_happened = true;
                      rest = argument.length - subindex - 1;
                      variables += "var " + (k()) + " = arguments[" + index + "].slice(" + subindex + ", arguments[" + index + "].length - " + rest + ");\n";
                    } else {
                      if (destructuring_happened) {
                        restindex = argument.length - subindex;
                        variables += "var " + (k()) + " = arguments[" + index + "][arguments[" + index + "].length - " + restindex + "];\n";
                      } else {
                        variables += "var " + (k()) + " = arguments[" + index + "][" + subindex + "];\n";
                      }
                    }
                  }
                } else {
                  plain_arguments.push("JSON.stringify(arguments[" + index + "]) === '" + (JSON.stringify(argument)) + "'");
                }
              } else if (typeof argument === 'string') {
                plain_arguments.push("arguments[" + index + "] === '" + argument + "'");
              } else {
                plain_arguments.push("arguments[" + index + "] === " + argument);
              }
            }
          }
          plain_arguments.push("arguments.length === " + args.length);
          duplicates = {};
          _ref1 = (function() {
            var _l, _len2, _results;
            _results = [];
            for (index = _l = 0, _len2 = args.length; _l < _len2; index = ++_l) {
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
          for (_k = 0, _len2 = _ref1.length; _k < _len2; _k++) {
            variable = _ref1[_k];
            if (variable.name !== '_') {
              if (duplicates[variable.name] != null) {
                plain_arguments.push("arguments[" + variable.index + "] === arguments[" + duplicates[variable.name] + "]");
              } else {
                duplicates[variable.name] = variable.index;
              }
            }
          }
          additional_condition_variables = [];
          for (index = _l = 0, _len3 = args.length; _l < _len3; index = ++_l) {
            arg = args[index];
            if (!(arg instanceof Array && arg.length > 0)) {
              continue;
            }
            destructuring_happened = false;
            for (subindex = _m = 0, _len4 = arg.length; _m < _len4; subindex = ++_m) {
              x = arg[subindex];
              if (x.destructuring) {
                destructuring_happened = true;
                rest = arg.length - subindex - 1;
                additional_condition_variables.push({
                  name: x(),
                  value: "arguments[" + index + "].slice(" + subindex + ", arguments[" + index + "].length - " + rest + ")"
                });
              } else {
                if (destructuring_happened) {
                  restindex = arg.length - subindex;
                  additional_condition_variables.push({
                    name: x(),
                    value: "arguments[" + index + "][arguments[" + index + "].length - " + restindex + "]"
                  });
                } else {
                  additional_condition_variables.push({
                    name: x(),
                    value: "arguments[" + index + "][" + subindex + "]"
                  });
                }
              }
            }
          }
          conditions = ((function() {
            var _len5, _n, _results;
            _results = [];
            for (_n = 0, _len5 = local_functions_map.length; _n < _len5; _n++) {
              x = local_functions_map[_n];
              if (x.name === this.fn_name) {
                _results.push(x);
              }
            }
            return _results;
          }).call(_this))[functions_calls[_this.fn_name] - 1].conditions;
          if (conditions != null) {
            plain_arguments.push("(function(" + (((function() {
              var _results;
              _results = [];
              for (name in duplicates) {
                _results.push(name);
              }
              return _results;
            })()).concat((function() {
              var _len5, _n, _results;
              _results = [];
              for (_n = 0, _len5 = additional_condition_variables.length; _n < _len5; _n++) {
                item = additional_condition_variables[_n];
                _results.push(item.name);
              }
              return _results;
            })()).join(', ')) + "){\n  return " + (conditions.join(' && ')) + "\n})(" + (((function() {
              var _results;
              _results = [];
              for (name in duplicates) {
                index = duplicates[name];
                _results.push("arguments[" + index + "]");
              }
              return _results;
            })()).concat((function() {
              var _len5, _n, _results;
              _results = [];
              for (_n = 0, _len5 = additional_condition_variables.length; _n < _len5; _n++) {
                item = additional_condition_variables[_n];
                _results.push(item.value);
              }
              return _results;
            })()).join(', ')) + ")");
          }
          pseudo[_this.fn_name] = pseudo[_this.fn_name] + ("if(" + (plain_arguments.join(" && ")) + "){\n  " + variables + "\n  return (" + fn + ")()\n}\n");
          return container[_this.fn_name] = build_function(pseudo[_this.fn_name]);
        };
      })(this);
    };
    build_function(content.toString().replace(/\n/g, ' ').replace(/function \(\) \{(.*) \}$/gmi, "$1"), uniq_functions_names.concat(uniq_variables_names).concat(['where']).concat(['__slice'])).apply(null, ((function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = uniq_functions_names.length; _i < _len; _i++) {
        item = uniq_functions_names[_i];
        _results.push(base_fn.bind({
          fn_name: item
        }));
      }
      return _results;
    })()).concat(variables_stubs).concat(function() {
      return function(fn) {
        return fn;
      };
    }).concat(function() {
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
    }));
    return true;
  };

}).call(this);
