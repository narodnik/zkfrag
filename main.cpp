#include <fstream>
#include <iostream>
#include <iterator>
#include <string>

#include "ast_parser.hpp"

int main()
{
    std::ifstream file("fragment.zkf");

    libdark::ast_parser parser;
    auto root = parser.parse(file);

    if (root)
        std::cout << "Parse successful." << std::endl;
    else
        std::cerr << "Parse failed." << std::endl;

    return root ? 1 : 0;
}

