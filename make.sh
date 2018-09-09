ctags --langmap=C++:+.ipp,Flex:+.l -R .
flex --outfile=src/sigma/parser/generated/scanner.cpp --header-file=src/sigma/parser/generated/scanner.hpp src/sigma/parser/scanner.l
bison --defines=src/sigma/parser/generated/parser.hpp --output=src/sigma/parser/generated/parser.cpp src/sigma/parser/parser.y
g++ -g -DYYDEBUG=1 -Iinclude/ src/math/sha256_combine.cpp src/parser/ast_parser_base.cpp main.cpp src/sigma/check_rules.cpp src/error.cpp src/sigma/variables_map.cpp src/sigma/sigma_ast_parser.cpp src/sigma/parser/generated/scanner.cpp src/sigma/parser/generated/parser.cpp src/sigma/sigma_ast_node.cpp $(pkg-config --cflags --libs libbitcoin) -o zkfrag
notify-send 'Compile Finished' 'Check your Terminal' --icon=dialog-information
