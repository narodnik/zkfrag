#ifndef LIBDARK_PIRROMEAN_WITNESS_IPP
#define LIBDARK_PIRROMEAN_WITNESS_IPP

namespace libdark {

template <typename CurveType>
pirr_witness<CurveType>::pirr_witness(const ec_point& commit)
  : commit_(commit)
{
}

template <typename CurveType>
pirr_witness<CurveType>::pirr_witness(
    const ec_scalar& secret, const ec_point& generator)
  : secret_(secret)
{
    commit_ = secret * generator;
}

template <typename CurveType>
pirr_witness<CurveType> pirr_witness<CurveType>::random(
    const ec_point& generator)
{
    typename CurveType::ec_secret secret;
    bc::pseudo_random::fill(secret);
    return pirr_witness<CurveType>(secret, generator);
}

template <typename CurveType>
pirr_witness<CurveType> pirr_witness<CurveType>::clone_public() const
{
    return pirr_witness(commit_);
}

template <typename CurveType>
bool pirr_witness<CurveType>::has_secret() const
{
    return (bool)secret_;
}
template <typename CurveType>
const typename pirr_witness<CurveType>::ec_scalar
pirr_witness<CurveType>::secret() const
{
    return *secret_;
}

template <typename CurveType>
const typename pirr_witness<CurveType>::ec_point&
pirr_witness<CurveType>::commit() const
{
    return commit_;
}

template <typename CurveType>
std::string pirr_witness<CurveType>::pretty(size_t indent) const
{
    indent *= 4;
    auto result = std::string(indent, ' ') + "witness:\n";
    auto add_line = [indent, &result](const std::string& line)
    {
        result += std::string(indent + 4, ' ') + line + "\n";
    };
    if (secret_)
        add_line("secret: " + bc::encode_base16(secret_->secret()));
    add_line("public: " + bc::encode_base16(commit_.point()));
    return result;
}

} // namespace libdark

#endif

