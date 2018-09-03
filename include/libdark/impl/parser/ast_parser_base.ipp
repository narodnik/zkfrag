#ifndef LIBDARK_PARSER_AST_PARSER_IPP
#define LIBDARK_PARSER_AST_PARSER_IPP

namespace libdark {

template <typename Driver, typename Scanner,
    typename Parser, typename AstNodePtr>
AstNodePtr ast_parser_base::parse(std::istream& stream)
{
    Driver driver;
    Scanner scanner(driver);
    Parser parser(scanner, driver);

    scanner.switch_streams(&stream, nullptr);
    int rc = parser.parse();
    if (rc != 0)
    {
        error_.location = driver.location();
        error_.message = driver.error_message;
        // Find line based off location within input stream
        return nullptr;
    }

    // Return root value
    return driver.root;
}

} // namespace libdark

#endif

