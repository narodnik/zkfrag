flex src/sigma/parser/scanner.l
bison src/sigma/parser/parser.y
g++ -DYYDEBUG=1 -Iinclude/ main.cpp src/sigma/check_rules.cpp src/sigma/parser/ast_parser_driver.cpp src/error.cpp src/sigma/variables_map.cpp src/sigma/ast_parser.cpp src/sigma/parser/generated/scanner.cpp src/sigma/parser/generated/parser.cpp src/sigma/ast_node.cpp $(pkg-config --cflags --libs libbitcoin) -o zkfrag
