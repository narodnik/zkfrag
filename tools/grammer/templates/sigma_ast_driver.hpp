#ifndef ${HEADER_PREFIX}_${CLASS_PREFIX}_AST_DRIVER_HPP
#define ${HEADER_PREFIX}_${CLASS_PREFIX}_AST_DRIVER_HPP

#include <libdark/parser/ast_driver.hpp>
#include <${include_path}/${class_prefix}_ast_node.hpp>

namespace ${library_name} {

typedef ast_driver<${class_prefix}_ast_node::ptr> ${class_prefix}_ast_driver;

} // namespace ${library_name}

#endif

