#ifndef LIBDARK_PIRROMEAN_KEYPAIR_IPP
#define LIBDARK_PIRROMEAN_KEYPAIR_IPP

namespace libdark {

template <typename CurveType>
pirr_keypair<CurveType>::pirr_keypair(
    const ec_point& publik, const ec_point& generator)
  : publik_(publik), generator_(generator)
{
}

template <typename CurveType>
pirr_keypair<CurveType>::pirr_keypair(
    const ec_scalar& secret, const ec_point& generator)
  : secret_(secret), generator_(generator)
{
    publik_ = secret * generator;
}

template <typename CurveType>
pirr_keypair<CurveType> pirr_keypair<CurveType>::random(
    const ec_point& generator)
{
    typename CurveType::ec_secret secret;
    bc::pseudo_random::fill(secret);
    return pirr_keypair<CurveType>(secret, generator);
}

template <typename CurveType>
pirr_keypair<CurveType> pirr_keypair<CurveType>::clone_public() const
{
    return pirr_keypair<CurveType>(publik_, generator_);
}

template <typename CurveType>
bool pirr_keypair<CurveType>::has_secret() const
{
    return (bool)secret_;
}
template <typename CurveType>
const typename pirr_keypair<CurveType>::ec_scalar&
pirr_keypair<CurveType>::secret() const
{
    return *secret_;
}

template <typename CurveType>
const typename pirr_keypair<CurveType>::ec_point&
pirr_keypair<CurveType>::public_() const
{
    return publik_;
}

template <typename CurveType>
const typename pirr_keypair<CurveType>::ec_point&
pirr_keypair<CurveType>::generator() const
{
    return generator_;
}

template <typename CurveType>
std::string pirr_keypair<CurveType>::pretty(size_t indent) const
{
    indent *= 4;
    auto result = std::string(indent, ' ') + "keypair:\n";
    auto add_line = [indent, &result](auto line)
    {
        result += std::string(indent + 4, ' ') + line + "\n";
    };
    if (secret_)
        add_line("secret: " + bc::encode_base16(secret_->secret()));
    add_line("generator: " + bc::encode_base16(generator_.point()));
    add_line("public: " + bc::encode_base16(publik_.point()));
    return result;
}

} // namespace libdark

#endif

