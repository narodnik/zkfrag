#ifndef LIBDARK_SIGMA_AST_PARSER_DRIVER_HPP
#define LIBDARK_SIGMA_AST_PARSER_DRIVER_HPP

#include <libdark/sigma/ast_node.hpp>

namespace libdark {

class ast_parser_driver
{
public:
    void increase_location(unsigned int distance);
    
    unsigned int location() const;

    ast_node_ptr root;

    std::string error_message;

private:
    unsigned int location_ = 0;
};

} // namespace libdark

#endif


