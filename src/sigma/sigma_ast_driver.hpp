#ifndef LIBDARK_SIGMA_AST_DRIVER_HPP
#define LIBDARK_SIGMA_AST_DRIVER_HPP

#include <libdark/parser/ast_driver.hpp>
#include <libdark/sigma/sigma_ast_node.hpp>

namespace libdark {

typedef ast_driver<sigma_ast_node::ptr> sigma_ast_driver;

} // namespace libdark

#endif

