#include <libdark/sigma/check_rules.hpp>

#include <libdark/utility/assert.hpp>

namespace libdark {

bool variable_listed(
    const libdark::ast_node_ptr node, const libdark::variables_map variables)
{
    if (node->type != ast_type::variable &&
        node->type != ast_type::private_value)
    {
        return true;
    }

    if (variables.find(node->value) == variables.end())
        return false;

    return true;
}

bool correct_children(
    const libdark::ast_node_ptr node, const libdark::variables_map variables)
{
    if (node->type == ast_type::represent)
    {
        if (node->children.size() != 1)
            return false;
        const auto child = node->children.front();
        if (child->type != ast_type::equal)
            return false;
        return true;
    }
    else if (node->type == ast_type::equal)
    {
        if (node->children.size() != 2)
            return false;
        for (const auto child: node->children)
            if (child->type != ast_type::sum)
                return false;
        return true;
    }
    else if (node->type == ast_type::sum)
    {
        if (node->children.empty())
            return false;
        for (const auto child: node->children)
            if (child->type != ast_type::multiply &&
                child->type != ast_type::negative &&
                child->type != ast_type::variable)
            {
                return false;
            }
        return true;
    }
    else if (node->type == ast_type::negative)
    {
        if (node->children.size() != 1)
            return false;
        const auto child = node->children.front();
        if (child->type != ast_type::multiply &&
            child->type != ast_type::variable)
        {
            return false;
        }
        return true;
    }
    else if (node->type == ast_type::multiply)
    {
        if (node->children.size() != 2)
            return false;
        for (const auto child: node->children)
            if (child->type != ast_type::variable &&
                child->type != ast_type::number)
            {
                return false;
            }
        return true;
    }
    return true;
}

bool scalar_by_point(
    const libdark::ast_node_ptr node, const libdark::variables_map variables)
{
    if (node->type != ast_type::multiply)
        return true;

    DARK_ASSERT(node->children.size() == 2);
    
    const auto first = node->children.front();
    const auto second = node->children.back();

    const auto first_it = variables.find(first->value);
    const auto second_it = variables.find(second->value);

    DARK_ASSERT(first_it != variables.end());
    DARK_ASSERT(second_it != variables.end());

    // First variable should be a scalar
    if (!first_it->second.scalar())
        return false;

    // Second should be a point
    if (!second_it->second.point())
        return false;

    return true;
}

bool private_is_scalar(
    const libdark::ast_node_ptr node, const libdark::variables_map variables)
{
    if (node->type != ast_type::private_value)
        return true;

    const auto iterator = variables.find(node->value);
    DARK_ASSERT(iterator != variables.end());

    if (!iterator->second.scalar())
        return false;

    return true;
}

rules_error_result check_rules(
    const libdark::ast_node_ptr root, const libdark::variables_map variables)
{
    const auto flat = libdark::flatten_tree(root);

    // All variables are listed
    for (const auto node: flat)
        if (!variable_listed(node, variables))
            return { error::missing_variable, node };

    // Correct hierarchy for nodes in proof
    for (const auto node: flat)
        if (!correct_children(node, variables))
            return { error::invalid_children, node };

    // Only ever multiply scalar by a point
    for (const auto node: flat)
        if (!scalar_by_point(node, variables))
            return { error::invalid_multiplication, node };

    // Private values are only scalars
    for (const auto node: flat)
        if (!private_is_scalar(node, variables))
            return { error::non_scalar_private, node };

    // Checks passed
    return { error::success, nullptr };
}

} // namespace libdark

