#ifndef LIBDARK_SIGMA_SIGMA_AST_PARSER
#define LIBDARK_SIGMA_SIGMA_AST_PARSER

#include <libdark/parser/ast_parser_base.hpp>
#include <libdark/sigma/sigma_ast_node.hpp>

namespace libdark {

class sigma_ast_parser
  : public ast_parser_base
{
public:
    sigma_ast_node::ptr parse(std::istream& stream);
};

} // namespace libdark

#endif

