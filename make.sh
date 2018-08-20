flex lexer.l
bison -d parser.y
g++ generated/lexer.cpp generated/parser.cpp expression.cpp -lfl -o snazzle
