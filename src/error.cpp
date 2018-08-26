#include <libdark/error.hpp>

#include <unordered_map>

class error_category_impl
  : public std::error_category
{
public:
    virtual const char* name() const noexcept;
    virtual std::string message(int ev) const;
};

static const error_category_impl& get_error_category_instance()
{
    static error_category_impl instance;
    return instance;
}

const char* error_category_impl::name() const noexcept
{
    return "libdark";
}

std::string error_category_impl::message(int ev) const
{
    switch (static_cast<libdark::error>(ev))
    {
    case libdark::error::success:
        return "success";
    case libdark::error::missing_variable:
        return "missing variable";
    case libdark::error::invalid_children:
        return "invalid children";
    case libdark::error::invalid_multiplication:
        return "invalid_multiplication";
    case libdark::error::non_scalar_private:
        return "non scalar private value";
    }
    return "invalid code";
}

namespace libdark {

std::error_code make_error_code(error ec)
{
    return std::error_code(static_cast<int>(ec), get_error_category_instance());
}

} // namespace libdark

