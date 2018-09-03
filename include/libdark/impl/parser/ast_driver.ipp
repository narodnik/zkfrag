#ifndef LIBDARK_PARSER_AST_DRIVER_IPP
#define LIBDARK_PARSER_AST_DRIVER_IPP

namespace libdark {

template <typename AstNodePtr>
void ast_driver<AstNodePtr>::increase_location(unsigned int distance)
{
    location_ += distance;
}

template <typename AstNodePtr>
unsigned int ast_driver<AstNodePtr>::location() const
{
    return location_;
}

} // namespace libdark

#endif
