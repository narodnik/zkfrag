#ifndef LIBDARK_SIGMA_VARIABLES_PARSER_HPP
#define LIBDARK_SIGMA_VARIABLES_PARSER_HPP

#include <iostream>
#include "variables_map.hpp"

namespace libdark {

struct variables_parser_error
{
    size_t location;
    std::string message;
};

class variables_parser
{
public:
    variables_map parse(std::istream& stream);

    const variables_parser_error error() const;

private:
    variables_parser_error error_;
};

class variables_parser_driver
{
public:
    void increase_location(unsigned int distance);
    
    unsigned int location() const;

    variables_map map;

    std::string error_message;

private:
    unsigned int location_ = 0;
};

} // namespace libdark

#endif

