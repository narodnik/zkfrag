#ifndef LIBDARK_PARSER_AST_DRIVER_HPP
#define LIBDARK_PARSER_AST_DRIVER_HPP

namespace libdark {

template <typename AstNodePtr>
class ast_driver
{
public:
    void increase_location(unsigned int distance);
    
    unsigned int location() const;

    AstNodePtr root;

    std::string error_message;

private:
    unsigned int location_ = 0;
};

} // namespace libdark

#include <libdark/impl/parser/ast_driver.ipp>

#endif


