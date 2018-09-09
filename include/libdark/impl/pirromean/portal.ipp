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
const typename pirr_portal<CurveType>::witness_list&
pirr_portal<CurveType>::witnesses() const
{
    return witnesses_;
}

template <typename CurveType>
typename pirr_portal<CurveType>::gate_wptr
pirr_portal<CurveType>::input() const
{
    return input_;
}
template <typename CurveType>
typename pirr_portal<CurveType>::gate_wptr
pirr_portal<CurveType>::output() const
{
    return output_;
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

template <typename CurveType>
bool pirr_portal<CurveType>::is_signing_portal() const
{
    for (const auto& key: keys_)
        if (!key.secret())
            return false;
    return true;
}
template <typename CurveType>
void pirr_portal<CurveType>::create_random_responses()
{
    DARK_ASSERT(responses_.empty());
    responses_.reserve(keys_.size());
    for (const auto& key: keys_)
    {
        typename CurveType::ec_secret secret;
        bc::pseudo_random::fill(secret);
        responses_.push_back(secret);
    }
}
template <typename CurveType>
void pirr_portal<CurveType>::derive_witnesses()
{
    auto input = input_.lock();
    DARK_ASSERT(input);
    DARK_ASSERT(input->has_challenge());
    const auto& challenge = input->challenge();

    DARK_ASSERT(keys_.size() == responses_.size());
    DARK_ASSERT(witnesses_.empty());
    witnesses_.reserve(keys_.size());

    for (size_t i = 0; i < keys_.size(); ++i)
    {
        const auto& key = keys_[i];
        const auto& response = responses_[i];

        auto commit = response * key.generator() - challenge * key.public_();
        witnesses_.push_back(commit);
    }
}
template <typename CurveType>
void pirr_portal<CurveType>::create_random_witnesses()
{
    DARK_ASSERT(witnesses_.empty());
    witnesses_.reserve(keys_.size());

    for (size_t i = 0; i < keys_.size(); ++i)
    {
        const auto& key = keys_[i];
        auto witness = witness_type::random(key.generator());
        witnesses_.push_back(witness);
    }
}

template <typename KeypairType, typename WitnessType, typename EcScalar>
void debug_verify_witness(KeypairType key, WitnessType witness,
    const EcScalar& response, const EcScalar& challenge)
{
    auto commit = response * key.generator() - challenge * key.public_();
    DARK_ASSERT(witness.commit() == witness.secret() * key.generator());
    DARK_ASSERT(witness.commit() == commit);
}

template <typename CurveType>
void pirr_portal<CurveType>::compute_valid_responses()
{
    auto input = input_.lock();
    DARK_ASSERT(input);
    DARK_ASSERT(input->has_challenge());
    const auto& challenge = input->challenge();

    DARK_ASSERT(keys_.size() == witnesses_.size());
    DARK_ASSERT(responses_.empty());
    for (size_t i = 0; i < keys_.size(); ++i)
    {
        const auto& key = keys_[i];
        const auto& witness = witnesses_[i];
        DARK_ASSERT(key.has_secret());
        DARK_ASSERT(witness.has_secret());

        auto response = witness.secret() + challenge * key.secret();
        responses_.push_back(response);

        debug_verify_witness(key, witness, response, challenge);
    }
}

} // namespace libdark

#endif

