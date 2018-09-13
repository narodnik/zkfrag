#include <libdark/sigma/sigma_ast_node.hpp>

#include <libdark/utility/assert.hpp>

namespace libdark {

std::string ast_type_to_string(const sigma_ast_type type)
{
    switch (type)
    {
            case sigma_ast_type::negative:
        return "negative";
    case sigma_ast_type::equal:
        return "equal";
    case sigma_ast_type::less:
        return "less";
    case sigma_ast_type::range_proof:
        return "range_proof";
    case sigma_ast_type::private_section:
        return "private_section";
    case sigma_ast_type::variable:
        return "variable";
    case sigma_ast_type::private_value:
        return "private_value";
    case sigma_ast_type::version:
        return "version";
    case sigma_ast_type::sum:
        return "sum";
    case sigma_ast_type::any:
        return "any";
    case sigma_ast_type::less_equal:
        return "less_equal";
    case sigma_ast_type::linear_equation:
        return "linear_equation";
    case sigma_ast_type::greater:
        return "greater";
    case sigma_ast_type::root:
        return "root";
    case sigma_ast_type::multiply:
        return "multiply";
    case sigma_ast_type::template_:
        return "template_";
    case sigma_ast_type::represent:
        return "represent";
    case sigma_ast_type::greater_equal:
        return "greater_equal";
    case sigma_ast_type::prove_section:
        return "prove_section";
    case sigma_ast_type::number:
        return "number";
    case sigma_ast_type::all:
        return "all";

    }
    DARK_ASSERT(false);
    // Shouldn't ever reach here!
    return "ERROR";
}

} // namespace libdark

