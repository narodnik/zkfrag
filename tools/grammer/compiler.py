class CodeCompiler:

    def __init__(self, options, tokens, grammars):
        self.options = options
        self.tokens = tokens
        self.grammars = grammars

        self.node_types = set()

    def compile(self):
        self._result = ""
        for name, sub_grammars in self.grammars:
            self._result += "%s:\n" % name
            for sub_grammar in sub_grammars:
                self._write_subgrammar(sub_grammar)
        return self._result

    def _write_subgrammar(self, sub_grammar):
        rules, code = sub_grammar
        self._result += "    "
        self._result += " ".join(rules) + "\n"
        self._result += "    {\n"
        self._write_code(code)
        self._result += "    }\n"
        self._result += "    ;\n"

    def _write_code(self, code):
        for instruction, arguments in code:
            if instruction == "init":
                self._write_init(arguments)
            elif instruction == "return":
                self._write_return(arguments)
            elif instruction == "add":
                self._write_add(arguments)
            elif instruction == "assign":
                self._write_assign(arguments)
            else:
                print(instruction)
                print(arguments)
                assert False

    def _write_init(self, arguments):
        assert len(arguments) == 5
        (varname, init_type, init_data,
         init_inherit, init_children) = arguments

        # Special keywords in C++
        if init_type == "template":
            init_type = "template_"

        self._write_code_line(
            "auto %s = std::make_shared<libdark::sigma_ast_node>(" % varname)
        value_data = ""
        if init_data is not None:
            value_data = ", %s" % init_data
        elif init_inherit is not None:
            value_data = ", %s->value" % init_inherit
        self._write_code_line(
            "    libdark::sigma_ast_type::%s%s);" % (init_type, value_data))
        for child in init_children:
            self._write_code_line(
                "%s->children.push_back(%s);" % (varname, child))
        if init_inherit is not None:
            self._write_code_line(
                "%s->children = std::move(%s->children);" % 
                    (varname, init_inherit))

        self.node_types.add(init_type)

    def _write_return(self, argument):
        self._write_code_line(
            "$$ = %s;" % argument)

    def _write_add(self, arguments):
        assert len(arguments) == 2
        self._write_code_line(
            "%s->children.push_back(%s);" % arguments)

    def _write_assign(self, arguments):
        assert len(arguments) == 2
        self._write_code_line(
            "auto %s = %s;" % arguments)

    def _write_code_line(self, string):
        self._result += " " * 8 + string + "\n"

    def compile_node_types(self):
        lines = []
        for node_type in self.node_types:
            lines.append(" " * 4 + node_type)
        return ",\n".join(lines)

    def compile_ast_type_to_string(self):
        result = ""
        for node_type in self.node_types:
            result += " " * 4 + "case %s_ast_type::%s:\n" % (
                self.options["class_prefix"], node_type)
            result += " " * 8 + 'return "%s";\n' % node_type
        return result

class FlexCompiler:

    def __init__(self, options, tokens):
        self.options = options
        self.tokens = tokens

    def compile(self):
        result = ""
        for token, cname in self.tokens:
            result += token
            adjust = 8 - len(token)
            if adjust <= 0:
                adjust = 1
            result += " " * adjust
            if cname is None:
                result += ";\n"
            else:
                result += self._return_segment(cname)
        return result

    def _return_segment(self, cname):
        return ("{\n" +
            " " * 12 + "return %s::%s_bison_parser::make_%s(\n" % (
                self.options["library_name"], self.options["class_prefix"],
                cname) +
            " " * 16 + "libdark::location());\n" +
            " " * 8 + "}\n")

