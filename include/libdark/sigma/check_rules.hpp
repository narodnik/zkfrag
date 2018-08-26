#ifndef LIBDARK_SIGMA_CHECK_RULES_HPP
#define LIBDARK_SIGMA_CHECK_RULES_HPP

#include <libdark/error.hpp>
#include <libdark/sigma/ast_node.hpp>
#include <libdark/sigma/variables_map.hpp>

namespace libdark {

std::error_code check_rules(
    const ast_node_ptr node, const variables_map variables);

} // namespace libdark

#endif

