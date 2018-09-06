#ifndef ${HEADER_PREFIX}_${CLASS_PREFIX}_AST_NODE_HPP
#define ${HEADER_PREFIX}_${CLASS_PREFIX}_AST_NODE_HPP

#include <libdark/parser/ast_node.hpp>

namespace ${library_name} {

enum class ${class_prefix}_ast_type
{
    ${node_types}
};

std::string ast_type_to_string(const ${class_prefix}_ast_type type);

typedef ast_node<${class_prefix}_ast_type> ${class_prefix}_ast_node;

} // namespace ${library_name}

#endif

