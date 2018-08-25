#include "ast_node.hpp"

#include <cassert>

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
        case ast_type::token:
            return "token";
    }
    assert(false);
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

