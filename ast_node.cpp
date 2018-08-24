#include "ast_node.hpp"

namespace libdark {

ast_node::ast_node(const std::string& value)
  : type_(operation_type::value), value_(value),
    left_(nullptr), right_(nullptr)
{
}

ast_node::ast_node(operation_type type,
    ast_node_ptr left, ast_node_ptr right)

  : type_(type), left_(left), right_(right)
{
}

ast_node::~ast_node()
{
}

void ast_node::set_parent(ast_node_weakptr parent)
{
    parent_ = parent;
}

const operation_type ast_node::type() const
{
    return type_;
}
const std::string& ast_node::value() const
{
    return value_;
}

const ast_node_ptr ast_node::left() const
{
    return left_;
}
const ast_node_ptr ast_node::right() const
{
    return right_;
}
const ast_node_weakptr ast_node::parent() const
{
    return parent_;
}

} // namespace libdark

