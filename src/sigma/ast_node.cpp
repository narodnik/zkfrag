#include <libdark/sigma/ast_node.hpp>

#include <libdark/utility/assert.hpp>

namespace libdark {

std::string ast_type_to_string(const ast_type type)
{
    switch (type)
    {
        case ast_type::root:
            return "root";
        case ast_type::version:
            return "version";
        case ast_type::private_section:
            return "private_section";
        case ast_type::private_value:
            return "private_value";
        case ast_type::prove_section:
            return "prove_section";
        case ast_type::represent:
            return "represent";
        case ast_type::linear_equation:
            return "linear_equation";
        case ast_type::range_proof:
            return "range_proof";
        case ast_type::any:
            return "any";
        case ast_type::all:
            return "all";
        case ast_type::equal:
            return "equal";
        case ast_type::less_equal:
            return "less_equal";
        case ast_type::greater_equal:
            return "greater_equal";
        case ast_type::less:
            return "less";
        case ast_type::greater:
            return "greater";
        case ast_type::variable:
            return "variable";
        case ast_type::sum:
            return "sum";
        case ast_type::multiply:
            return "multiply";
        case ast_type::number:
            return "number";
    }
    DARK_ASSERT(false);
    // Shouldn't ever reach here!
    return "ERROR";
}

ast_node::ast_node(const ast_type type)
  : type(type)
{
}
ast_node::ast_node(const ast_type type, const std::string &value)
  : type(type), value(value)
{
}

} // namespace libdark

