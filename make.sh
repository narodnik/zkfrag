#!/bin/bash
ctags --langmap=C++:+.ipp,Flex:+.l -R .
#flex --outfile=src/sigma/parser/generated/scanner.cpp --header-file=src/sigma/parser/generated/scanner.hpp src/sigma/parser/scanner.l
#bison --defines=src/sigma/parser/generated/parser.hpp --output=src/sigma/parser/generated/parser.cpp src/sigma/parser/parser.y
make install
./tools/zkfrag/zkfrag
notify-send 'Compile Finished' 'Check your Terminal' --icon=dialog-information
