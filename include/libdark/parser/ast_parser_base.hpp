#ifndef LIBDARK_PARSER_AST_PARSER_BASE_HPP
#define LIBDARK_PARSER_AST_PARSER_BASE_HPP

#include <iostream>
#include <libdark/parser/ast_node.hpp>

namespace libdark {

struct ast_parser_error
{
    size_t location;
    std::string message;
};

class ast_parser_base
{
public:
    const ast_parser_error error() const;

protected:
    template <typename Driver, typename Scanner,
        typename Parser, typename AstNodePtr>
    AstNodePtr parse(std::istream& stream);

private:
    ast_parser_error error_;
};

} // namespace libdark

#include <libdark/impl/parser/ast_parser_base.ipp>

#endif

