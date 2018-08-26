#include "ast_parser_driver.hpp"

namespace libdark {

void ast_parser_driver::increase_location(unsigned int distance)
{
    location_ += distance;
}

unsigned int ast_parser_driver::location() const
{
    return location_;
}

} // namespace libdark

