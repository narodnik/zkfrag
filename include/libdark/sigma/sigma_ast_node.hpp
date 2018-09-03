#ifndef LIBDARK_SIGMA_SIGMA_AST_NODE_HPP
#define LIBDARK_SIGMA_SIGMA_AST_NODE_HPP

#include <libdark/parser/ast_node.hpp>

namespace libdark {

enum class sigma_ast_type
{
    template_,
    root,
    version,
    private_section,
    private_value,
    prove_section,
    represent,
    linear_equation,
    range_proof,
    any,
    all,
    equal,
    less_equal,
    greater_equal,
    less,
    greater,
    sum,
    multiply,
    variable,
    negative,
    number
};

std::string ast_type_to_string(const sigma_ast_type type);

typedef ast_node<sigma_ast_type> sigma_ast_node;

} // namespace libdark

#endif

