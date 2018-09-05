class Compiler:

    def __init__(self, options, tokens, grammars):
        self.options = options
        self.tokens = tokens
        self.grammars = grammars

    def write(self, outfile):
        for name, sub_grammars in self.grammars:
            outfile.write("%s:\n" % name)
            for sub_grammar in sub_grammars:
                self._write_subgrammar(outfile, sub_grammar)

    def _write_subgrammar(self, outfile, sub_grammar):
        rules, code = sub_grammar
        outfile.write("    ")
        outfile.write(" ".join(rules) + "\n")
        outfile.write("    {\n")
        self._write_code(outfile, code)
        outfile.write("    }\n")
        outfile.write("    ;\n")

    def _write_code(self, outfile, code):
        for instruction, arguments in code:
            if instruction == "init":
                self._write_init(outfile, arguments)
            elif instruction == "return":
                self._write_return(outfile, arguments)
            elif instruction == "add":
                self._write_add(outfile, arguments)
            elif instruction == "assign":
                self._write_assign(outfile, arguments)
            else:
                print(instruction)
                print(arguments)
                assert False

    def _write_init(self, outfile, arguments):
        assert len(arguments) == 5
        (varname, init_type, init_data,
         init_inherit, init_children) = arguments
        self._write_code_line(outfile,
            "auto %s = std::make_shared<libdark::sigma_ast_node>(" % varname)
        value_data = ""
        if init_data is not None:
            value_data = ", %s" % init_data
        elif init_inherit is not None:
            value_data = ", %s->value" % init_inherit
        self._write_code_line(outfile,
            "    libdark::sigma_ast_type::%s%s);" % (init_type, value_data))
        for child in init_children:
            self._write_code_line(outfile,
                "%s->children.push_back(%s);" % (varname, child))
        if init_inherit is not None:
            self._write_code_line(outfile,
                "%s->children = std::move(%s->children);" % 
                    (varname, init_inherit))

    def _write_return(self, outfile, argument):
        self._write_code_line(outfile,
            "$$ = %s;" % argument)

    def _write_add(self, outfile, arguments):
        assert len(arguments) == 2
        self._write_code_line(outfile,
            "%s->children.push_back(%s);" % arguments)

    def _write_assign(self, outfile, arguments):
        assert len(arguments) == 2
        self._write_code_line(outfile,
            "auto %s = %s;" % arguments)

    def _write_code_line(self, outfile, string):
        outfile.write(" " * 8 + string + "\n")

