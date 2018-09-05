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
        | "<" init_type ">" "from" value
    init_type : CNAME
    init_data : ":" PARSER_ARGUMENT
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
    print("Grammar:", grammar.pretty())
    name = grammar.children[0]
    print("************************")
    print("Name:", name)
    print("************************")
    for sub_grammar in grammar.children[1:]:
        parse_subgrammar(sub_grammar)

def parse_subgrammar(sub_grammar):
    assert sub_grammar.data == "sub_grammar"
    rules_tree = sub_grammar.children
    rules = []
    for rule in rules_tree[:-1]:
        rules.append(str(rule))
    print("Rules:", rules)
    code = rules_tree[-1].children
    print("Code:", code)
    parse_code(code)
    print()

def parse_grammars(grammars):
    #parse_grammar(grammars[0])
    #parse_grammar(grammars[1])
    parse_grammar(grammars[2])

def parse_code(code):
    for expr in code:
        stack = []
        parse_expr(expr, stack)

def parse_expr(expr, stack):
    if type(expr) == Token:
        return str(expr)
    elif expr.data == "return":
        assert len(expr.children) == 1
        varname = parse_expr(expr.children[0], stack)
        print("Return", varname)
    elif expr.data == "init":
        varname = random_variable_name()
        parse_init(varname, expr.children)
        return varname

def parse_init(varname, init):
    assert init[0].data == "init_type"
    assert len(init[0].children) == 1
    init_type = str(init[0].children[0])
    init_children = []
    for opts in init[1:]:
        if opts.data == "init_children":
            for child in opts.children:
                init_children.append(str(child))
    print("Init:", varname, "=", init_type, init_children)

def main():
    text = open("grammer.y").read()

    result = json_parser.parse(text)
    print(result.pretty())
    print()
    assert result.data == "program"
    for child in result.children:
        if child.data == "options":
            options = parse_options(child.children)
            print("Options:", options)
        elif child.data == "tokens":
            tokens = parse_tokens(child.children)
            for token, cname in tokens:
                print("Token:", token, "\t", cname)
        elif child.data == "grammars":
            #print(child.pretty())
            parse_grammars(child.children)

if __name__ == "__main__":
    main()

