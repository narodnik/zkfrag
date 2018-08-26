#ifndef LIBDARK_ERROR_HPP
#define LIBDARK_ERROR_HPP

#include <system_error>

namespace libdark {

enum class error
{
    success = 0,
    missing_variable
};

std::error_code make_error_code(error ec);

} // namespace libdark

namespace std {

template <>
struct is_error_code_enum<libdark::error>
  : public true_type
{
};

} // namespace std

#endif

