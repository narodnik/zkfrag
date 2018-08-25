#include <fstream>
#include <iostream>
#include <iterator>
#include <string>

#include "ast_parser.hpp"

void print_ast(libdark::ast_node_ptr node, size_t indent=0)
{
    std::cout << std::string(indent, ' ')
        << libdark::ast_type_to_string(node->type);
    if (!node->value.empty())
        std::cout << ": " << node->value;
    std::cout << std::endl;
    for (auto child: node->children)
        print_ast(child, indent + 2);
}

int main()
{
    std::ifstream file("fragment.zkf");

    libdark::ast_parser parser;
    auto root = parser.parse(file);

    if (!root)
    {
        std::cerr << "Parse failed." << std::endl;
        return -1;
    }

    std::cout << "Parse successful:" << std::endl << std::endl;

    print_ast(root);

    return 0;
}

