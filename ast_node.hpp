#ifndef LIBDARK_AST_NODE_HPP
#define LIBDARK_AST_NODE_HPP

#include <memory>

namespace libdark {

class ast_node;
typedef std::shared_ptr<ast_node> ast_node_ptr;
typedef std::weak_ptr<ast_node> ast_node_weakptr;

enum class ast_node_type
{
    root,
    version,
    private_value,
    token
};

class ast_node
 : std::enable_shared_from_this<ast_node>
{
public:
    ast_node(const ast_node_type type, const std::string& value);
    ast_node(const ast_node_type type,
        ast_node_ptr left, ast_node_ptr right);

    ~ast_node();

    const ast_node_type type() const;
    const std::string& value() const;

    void set_left(ast_node_ptr left);
    void set_right(ast_node_ptr right);
    void set_parent(ast_node_weakptr parent);

    ast_node_ptr left() const;
    ast_node_ptr right() const;
    ast_node_weakptr parent() const;

private:
    const ast_node_type type_;
    const std::string value_;

    ast_node_ptr left_, right_;
    ast_node_weakptr parent_;
};

} // namespace libdark

#endif

