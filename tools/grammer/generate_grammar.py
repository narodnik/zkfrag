from lark import Lark

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

    expression: return | assign | add

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
    name = grammar.children[0]
    print("Name:", name)
    assert grammar.children[1].data == "sub_grammar"
    sub_grammars = grammar.children[1].children
    subs = []
    for sub_grammar in sub_grammars[:-1]:
        subs.append(str(sub_grammar))
    print("Subs:", subs)
    code = sub_grammars[-1].children
    print("Code:", code)

def parse_grammars(grammars):
    parse_grammar(grammars[0])

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

