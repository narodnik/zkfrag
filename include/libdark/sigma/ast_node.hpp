#ifndef LIBDARK_SIGMA_AST_NODE_HPP
#define LIBDARK_SIGMA_AST_NODE_HPP

#include <list>
#include <memory>

namespace libdark {

class ast_node;
typedef std::shared_ptr<ast_node> ast_node_ptr;
typedef std::list<ast_node_ptr> ast_node_list;

enum class ast_type
{
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
    number
};

std::string ast_type_to_string(const ast_type type);

struct ast_node
{
    ast_node(const ast_type type);
    ast_node(const ast_type type, const std::string &value);

    const ast_type type;
    const std::string value;

    ast_node_list children;
};

ast_node_list flatten_tree(ast_node_ptr node);

} // namespace libdark

#endif

