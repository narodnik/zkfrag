#ifndef LIBDARK_PARSER_AST_NODE_IPP
#define LIBDARK_PARSER_AST_NODE_IPP

#include <libdark/utility/assert.hpp>

namespace libdark {

template <typename AstType>
std::string ast_type_to_string(const AstType type)
{
    DARK_ASSERT(false);
    return std::string();
}

template <typename AstType>
ast_node<AstType>::ast_node(const AstType type)
  : type(type)
{
}

template <typename AstType>
ast_node<AstType>::ast_node(const AstType type, const std::string &value)
  : type(type), value(value)
{
}

template <typename AstNode>
typename AstNode::list flatten_tree(typename AstNode::ptr node)
{
    typename AstNode::list flat;
    flat.push_back(node);
    for (auto child: node->children)
    {
        auto subtree = flatten_tree<AstNode>(child);
        flat.splice(flat.end(), subtree);
    }
    return flat;
}

} // namespace libdark

#endif

