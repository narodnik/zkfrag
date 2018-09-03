flex src/sigma/parser/scanner.l
bison src/sigma/parser/parser.y
g++ -DYYDEBUG=1 -Iinclude/ src/parser/ast_parser_base.cpp main.cpp src/sigma/check_rules.cpp src/error.cpp src/sigma/variables_map.cpp src/sigma/sigma_ast_parser.cpp src/sigma/parser/generated/scanner.cpp src/sigma/parser/generated/parser.cpp src/sigma/sigma_ast_node.cpp $(pkg-config --cflags --libs libbitcoin) -o zkfrag
