#ifndef LIBDARK_SIGMA_CHECK_RULES_HPP
#define LIBDARK_SIGMA_CHECK_RULES_HPP

#include <utility>
#include <libdark/error.hpp>
#include <libdark/sigma/sigma_ast_node.hpp>
#include <libdark/sigma/variables_map.hpp>

namespace libdark {

typedef std::pair<std::error_code, const sigma_ast_node::ptr>
    rules_error_result;

rules_error_result check_rules(
    const sigma_ast_node::ptr root, const variables_map variables);

} // namespace libdark

#endif

