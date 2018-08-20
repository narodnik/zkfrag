flex lexer.l
bison -d parser.y
g++ generated/lexer.cpp generated/parser.cpp ast_node.cpp -lfl -o snazzle
