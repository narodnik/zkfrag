#ifndef ${HEADER_PREFIX}_${CLASS_PREFIX}_AST_PARSER
#define ${HEADER_PREFIX}_${CLASS_PREFIX}_AST_PARSER

#include <libdark/parser/ast_parser_base.hpp>
#include <${include_path}/${class_prefix}_ast_node.hpp>

namespace ${library_name} {

class ${class_prefix}_ast_parser
  : public ast_parser_base
{
public:
    ${class_prefix}_ast_node::ptr parse(std::istream& stream);
};

} // namespace ${library_name}

#endif

