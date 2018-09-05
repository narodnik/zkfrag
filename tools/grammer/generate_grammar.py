from lark import Lark
from lark.lexer import Token

json_parser = Lark(r"""

    program : options tokens grammars

    options : "options" "{" option* "}"
    option : CNAME "=" CNAME

    tokens : "tokens" "{" token_define* "}"

    token_define: TOKEN (CNAME | ";")

    grammars : "grammar" "{" grammar* "}"

    grammar : CNAME ":" sub_grammar ("|" sub_grammar)* ";"
    
    sub_grammar : CNAME* "{" code "}"

    code: expression*

    ?expression: return | assign | add

    assign : CNAME "=" init

    init : "<" init_type ">" (init_data)? (init_children)?
        | "<" init_type ">" init_inherit
    init_type : CNAME
    init_data : ":" PARSER_ARGUMENT
    init_inherit : "from" value
    init_children : "[" object* ("," object)* "]"

    ?object : init | value | add

    return : "return" object

    add : value ".add(" value ")"

    ?value : CNAME | PARSER_ARGUMENT

    STRING : /[a-zA-Z]+/
    PARSER_ARGUMENT : "$" DIGIT

    TOKEN : /(?:\[[^\]]*\]|\S)+/

    %import common.ESCAPED_STRING
    %import common.CNAME
    %import common.DIGIT
    %import common.WS
    %ignore WS

    """, start='program')

import compiler
import random
import string

def random_variable_name():
    return "_" + "".join(random.choices(string.ascii_uppercase + string.digits,
                         k=12))

def parse_options(options):
    result = {}
    for optnode in options:
        assert optnode.data == "option"
        assert len(optnode.children) == 2
        key = str(optnode.children[0])
        value = str(optnode.children[1])
        result[key] = value
    return result

def parse_tokens(tokens):
    result = []
    for token_pair in tokens:
        assert token_pair.data == "token_define"
        assert len(token_pair.children) in (1, 2)
        token = token_pair.children[0]
        cname = None
        if len(token_pair.children) == 2:
            cname = token_pair.children[1]
        result.append((str(token), str(cname)))
    return result

def parse_grammar(grammar):
    name = str(grammar.children[0])
    #print("************************")
    #print("Name:", name)
    #print("************************")
    #print(grammar.pretty())
    subs = []
    for sub_grammar in grammar.children[1:]:
        sub = parse_subgrammar(sub_grammar)
        subs.append(sub)
    return (name, subs)

def parse_subgrammar(sub_grammar):
    assert sub_grammar.data == "sub_grammar"
    rules_tree = sub_grammar.children
    rules = []
    for rule in rules_tree[:-1]:
        rules.append(str(rule))
    #print("Rules:", rules)

    code = rules_tree[-1].children
    stack = parse_code(code)

    #print("Stack:")
    #for item in stack:
    #    print(item)
    #print()
    return (rules, stack)

def parse_grammars(grammars):
    result = []
    for grammar in grammars:
        grammar = parse_grammar(grammar)
        result.append(grammar)
    return result

def parse_code(code):
    stack = []
    for expr in code:
        parse_expr(expr, stack)
    return stack

def parse_expr(expr, stack):
    if type(expr) == Token:
        return str(expr)
    elif expr.data == "return":
        assert len(expr.children) == 1
        varname = parse_expr(expr.children[0], stack)
        #print("Return", varname)
        stack.append(("return", varname))
    elif expr.data == "init":
        varname = random_variable_name()
        parse_init(varname, expr.children, stack)
        return varname
    elif expr.data == "add":
        assert len(expr.children) == 2
        value_1 = str(expr.children[0])
        value_2 = str(expr.children[1])
        #print("Add:", value_1, value_2)
        stack.append(("add", (value_1, value_2)))
        return value_1
    elif expr.data == "assign":
        assert len(expr.children) == 2
        value_1 = str(expr.children[0])
        varname = parse_expr(expr.children[1], stack)
        #print("Assign:", value_1, "=", varname)
        stack.append(("assign", (value_1, varname)))

def parse_init(varname, init, stack):
    assert init[0].data == "init_type"
    assert len(init[0].children) == 1
    init_type = str(init[0].children[0])
    init_data = None
    init_inherit = None
    init_children = []
    for opts in init[1:]:
        if opts.data == "init_data":
            init_data = str(opts.children[0])
        elif opts.data == "init_inherit":
            init_inherit = str(opts.children[0])
        elif opts.data == "init_children":
            for child in opts.children:
                child_name = parse_expr(child, stack)
                init_children.append(child_name)
    #if init_inherit is None:
    #    print("Init:", varname, "=", init_type, init_data, init_children)
    #else:
    #    print("Init:", varname, "=", init_type, "<-", init_inherit)
    stack.append(("init", (varname, init_type, init_data,
                           init_inherit, init_children)))

def main():
    text = open("grammer.y").read()

    result = json_parser.parse(text)
    #print(result.pretty())
    #print()
    assert result.data == "program"
    for child in result.children:
        if child.data == "options":
            options = parse_options(child.children)
            #print("Options:", options)
        elif child.data == "tokens":
            tokens = parse_tokens(child.children)
            #for token, cname in tokens:
            #    print("Token:", token, "\t", cname)
        elif child.data == "grammars":
            #print(child.pretty())
            grammars = parse_grammars(child.children)

    output = compiler.Compiler(options, tokens, grammars)
    import sys
    output.write(sys.stdout)

if __name__ == "__main__":
    main()

