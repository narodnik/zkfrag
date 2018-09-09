#include <libdark/math/sha256_combine.hpp>

#include "external/sha256.h"

namespace libdark {

struct sha256_context
{
    SHA256CTX context;
};

sha256_combine::sha256_combine()
  : context_(new sha256_context)
{
    SHA256Init(&context_->context);
}
sha256_combine::~sha256_combine() = default;

void sha256_combine::update(bc::data_slice data)
{
    SHA256Update(&context_->context, data.data(), data.size());
}

bc::hash_digest sha256_combine::result()
{
    bc::hash_digest hash;
    SHA256Final(&context_->context, hash.data());
    return hash;
}

} // namespace libdark

