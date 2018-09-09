#ifndef LIBDARK_MATH_SHA256_COMBINE
#define LIBDARK_MATH_SHA256_COMBINE

#include <memory>
#include <bitcoin/bitcoin.hpp>

namespace libdark {

struct sha256_context;

class sha256_combine
{
public:
    sha256_combine();
    ~sha256_combine();

    void update(bc::data_slice data);

    // Class is now invalid. Further use is UB.
    bc::hash_digest result();

private:
    typedef std::unique_ptr<sha256_context> context_uniqptr;

    context_uniqptr context_;
};

} // namespace libdark

#endif

