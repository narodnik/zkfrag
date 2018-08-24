#ifndef LIBDARK_AST_NODE_HPP
#define LIBDARK_AST_NODE_HPP

#include <memory>

namespace libdark {

class ast_node;
typedef std::shared_ptr<ast_node> ast_node_ptr;
typedef std::weak_ptr<ast_node> ast_node_weakptr;

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
        ast_node_ptr left, ast_node_ptr right);

    ~ast_node();

    void set_parent(ast_node_weakptr parent);

    const operation_type type() const;
    const std::string& value() const;

    const ast_node_ptr left() const;
    const ast_node_ptr right() const;
    const ast_node_weakptr parent() const;

private:
    const operation_type type_;
    const std::string value_;

    ast_node_ptr left_, right_;
    ast_node_weakptr parent_;
};

} // namespace libdark

#endif

