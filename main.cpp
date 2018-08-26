#include <fstream>
#include <iostream>
#include <iterator>
#include <string>

#include <libdark/sigma/ast_parser.hpp>
#include <libdark/sigma/check_rules.hpp>
#include <libdark/sigma/variables_map.hpp>

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

void print_error(const libdark::ast_parser_error& error, std::ifstream& file)
{
    std::cerr << "Error parsing fragment: " << error.message << std::endl;
    file.clear();
    file.seekg(0, std::ios::beg);

    size_t current_location = 0;
    size_t current_line = 0;
    for (std::string line; std::getline(file, line); )
    {
        if (current_location + line.size() >= error.location)
        {
            std::cerr << "Line " << current_line << ":" << std::endl;
            std::cerr << line << std::endl;
            break;
        }
        current_location += line.size() + 1;
        ++current_line;
    }

    const auto offset = error.location - current_location - 1;
    std::cerr << std::string(offset, ' ') << "^" << std::endl;
}

int main(int argc, char** argv)
{
    std::string filename = "fragment.zkf";
    if (argc == 2)
        filename = argv[1];
    std::cout << "Opening: " << filename << std::endl;

    std::ifstream file(filename);
    if (!file.is_open())
    {
        std::cerr << "Error opening file." << std::endl;
        return -1;
    }

    libdark::ast_parser parser;
    auto root = parser.parse(file);

    if (!root)
    {
        std::cerr << "Parse failed." << std::endl;
        print_error(parser.error(), file);
        return -1;
    }

    std::cout << "Parse successful:" << std::endl << std::endl;

    print_ast(root);

    libdark::variables_map variables;
    variables["G"] = bc::ec_point::G;
    variables["d"] = bc::ec_scalar(bc::base16_literal(
        "e3e796dcbd77e3565618d1feeb6ddc921f6531e417ed32182253ed564b764b3b"));
    const auto& G = *variables["G"].point();
    const auto& d = *variables["d"].scalar();
    variables["Q"] = d * G;

    const auto flat = libdark::flatten_tree(root);
    for (const auto node: flat)
    {
        const auto ec = check_rules(node, variables);
        if (ec)
        {
            std::cerr << "Error validating fragment: "
                << ec.message() << std::endl;
            print_ast(node);
            return -1;
        }
    }

    return 0;
}

