flex src/sigma/parser/scanner.l
bison src/sigma/parser/parser.y
g++ -DYYDEBUG=1 -Iinclude/ main.cpp src/sigma/ast_parser.cpp src/sigma/parser/generated/scanner.cpp src/sigma/parser/generated/parser.cpp src/sigma/ast_node.cpp -o zkfrag
