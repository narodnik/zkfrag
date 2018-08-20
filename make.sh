flex snazzle.l
bison -d snazzle.y
g++ snazzle.tab.c lex.yy.c -lfl -o snazzle
