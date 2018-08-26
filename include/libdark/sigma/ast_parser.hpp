#ifndef LIBDARK_SIGMA_AST_PARSER_HPP
#define LIBDARK_SIGMA_AST_PARSER_HPP

#include <iostream>
#include <libdark/sigma/ast_node.hpp>

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

} // namespace libdark

#endif

