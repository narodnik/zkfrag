#ifndef LIBDARK_PARSER_AST_NODE_HPP
#define LIBDARK_PARSER_AST_NODE_HPP

#include <list>
#include <memory>

namespace libdark {

template <typename AstType>
struct ast_node
{
    typedef std::shared_ptr<ast_node<AstType>> ptr;
    typedef std::list<ptr> list;

    ast_node(const AstType type);
    ast_node(const AstType type, const std::string &value);

    const AstType type;
    const std::string value;

    list children;
};

template <typename AstNode>
typename AstNode::list flatten_tree(typename AstNode::ptr node);

} // namespace libdark

#include <libdark/impl/parser/ast_node.ipp>

#endif

