#include "ast_node.hpp"

namespace libdark {

ast_node::ast_node(const std::string& value)
  : type_(operation_type::value), value_(value),
    left_(nullptr), right_(nullptr)
{
}

ast_node::ast_node(operation_type type,
    ast_node* left, ast_node* right)

  : type_(type), left_(left), right_(right)
{
}

ast_node::~ast_node()
{
    delete left_;
    delete right_;
}

void ast_node::set_parent(ast_node* parent)
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

const ast_node* ast_node::left() const
{
    return left_;
}
const ast_node* ast_node::right() const
{
    return right_;
}
const ast_node* ast_node::parent() const
{
    return parent_;
}

} // namespace libdark

