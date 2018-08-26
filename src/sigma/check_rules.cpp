#include <libdark/sigma/check_rules.hpp>

namespace libdark {

std::error_code check_rules(
    const libdark::ast_node_ptr node, const libdark::variables_map variables)
{
    // All variables are listed
    if (node->type == ast_type::variable)
    {
        if (variables.find(node->value) == variables.end())
            return error::missing_variable;
    }
    return error::success;
}

} // namespace libdark

