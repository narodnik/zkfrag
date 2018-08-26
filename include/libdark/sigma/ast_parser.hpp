#ifndef LIBDARK_SIGMA_AST_PARSER_HPP
#define LIBDARK_SIGMA_AST_PARSER_HPP

#include <iostream>
#include "ast_node.hpp"

namespace libdark {

struct ast_parser_error
{
    size_t location;
    std::string message;
};

class ast_parser
{
public:
    ast_node_ptr parse(std::istream& stream);

    const ast_parser_error error() const;

private:
    ast_parser_error error_;
};

class ast_parser_driver
{
public:
    void increase_location(unsigned int distance);
    
    unsigned int location() const;

    ast_node_ptr root;

    std::string error_message;

private:
    unsigned int location_ = 0;
};

} // namespace libdark

#endif

