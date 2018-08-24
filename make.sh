flex scanner.l
bison parser.y
g++ -DYYDEBUG=1 main.cpp ast_parser.cpp generated/scanner.cpp generated/parser.cpp command.cpp ast_node.cpp -o snazzle
