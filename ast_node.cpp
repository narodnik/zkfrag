#include "ast_node.hpp"

namespace libdark {

ast_node::ast_node(const ast_node_type type, const std::string& value)
  : type_(type), value_(value),
    left_(nullptr), right_(nullptr)
{
}

ast_node::ast_node(const ast_node_type type,
    ast_node_ptr left, ast_node_ptr right)

  : type_(type), left_(left), right_(right)
{
}

ast_node::~ast_node()
{
}

const ast_node_type ast_node::type() const
{
    return type_;
}
const std::string& ast_node::value() const
{
    return value_;
}

void ast_node::set_left(ast_node_ptr left)
{
    //ast_node_weakptr weak_this(shared_from_this());
    //left->set_parent(weak_this);
    left_ = left;
}
void ast_node::set_right(ast_node_ptr right)
{
    //ast_node_weakptr weak_this(shared_from_this());
    //right->set_parent(weak_this);
    right_ = right;
}
void ast_node::set_parent(ast_node_weakptr parent)
{
    parent_ = parent;
}

ast_node_ptr ast_node::left() const
{
    return left_;
}
ast_node_ptr ast_node::right() const
{
    return right_;
}
ast_node_weakptr ast_node::parent() const
{
    return parent_;
}

} // namespace libdark

