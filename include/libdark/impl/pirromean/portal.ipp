#ifndef LIBDARK_PIRROMEAN_PORTAL_IPP
#define LIBDARK_PIRROMEAN_PORTAL_IPP

namespace libdark {

template <typename CurveType>
pirr_portal<CurveType>::pirr_portal(const keypair_list& keys)
  : keys_(keys)
{
    witnesses_.reserve(keys_.size());
    responses_.reserve(keys_.size());
}

template <typename CurveType>
std::string pirr_portal<CurveType>::pretty(size_t indent) const
{
    auto result = std::string(indent * 4, ' ') + "portal:\n";
    for (const auto& key: keys_)
        result += key.pretty(indent + 1) + '\n';
    for (const auto& witness: witnesses_)
        result += witness.pretty(indent + 1) + '\n';
    for (const auto& response: responses_)
        result += std::string((indent + 1) * 4, ' ') + "response: " +
            bc::encode_base16(response.secret()) + '\n';
    return result;
}

} // namespace libdark

#endif

