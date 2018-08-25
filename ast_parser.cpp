#include "ast_parser.hpp"

#include "scanner.hpp"
#include "generated/parser.hpp"

namespace libdark {

ast_node_ptr ast_parser::parse(std::istream& stream)
{
    ast_driver driver;
    flex_scanner scanner(driver);
    bison_parser parser(scanner, driver);

    scanner.switch_streams(&stream, nullptr);
    int rc = parser.parse();
    if (rc != 0)
    {
        // Find line based off location within input stream
        return nullptr;
    }

    // Return root value
    return driver.root;
}

void ast_driver::increase_location(unsigned int distance)
{
    location_ += distance;
}

unsigned int ast_driver::location() const
{
    return location_;
}

} // namespace libdark

