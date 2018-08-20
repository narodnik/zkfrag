#ifndef LIBDARK_EXPRESSION_HPP
#define LIBDARK_EXPRESSION_HPP

#include <memory>

namespace libdark {

enum class operation_type
{
    root,
    value
};

class ast_node
{
public:
    ast_node(const std::string& value);
    ast_node(operation_type type,
        ast_node* left, ast_node* right);

    ~ast_node();

    void set_parent(ast_node* parent);

    const operation_type type() const;
    const std::string& value() const;

    const ast_node* left() const;
    const ast_node* right() const;
    const ast_node* parent() const;

private:
    const operation_type type_;
    const std::string value_;

    ast_node* left_, * right_;
    ast_node* parent_;
};

} // namespace libdark

#endif

