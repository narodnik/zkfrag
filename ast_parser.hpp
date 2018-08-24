#ifndef LIBDARK_PARSER_HPP
#define LIBDARK_PARSER_HPP

#include <iostream>
#include "ast_node.hpp"

namespace libdark {

class ast_parser
{
public:
    ast_node_ptr parse(std::istream& stream);
};

class ast_driver
{
public:
    void increase_location(unsigned int distance);
    
    unsigned int location() const;

private:
    unsigned int location_ = 0;
};

} // namespace libdark

#endif

