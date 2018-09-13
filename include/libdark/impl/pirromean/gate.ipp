#ifndef LIBDARK_PIRROMEAN_GATE_IPP
#define LIBDARK_PIRROMEAN_GATE_IPP

#include <bitcoin/bitcoin.hpp>
#include <libdark/math/sha256_combine.hpp>

namespace libdark {

template <typename CurveType>
pirr_gate<CurveType>::pirr_gate(size_t index)
  : index_(index)
{
}

template <typename CurveType>
typename pirr_gate<CurveType>::ptr pirr_gate<CurveType>::clone_public() const
{
    auto result = std::make_shared<pirr_gate>(index_);
    result->challenge_ = challenge_;
    return result;
}

template <typename CurveType>
size_t pirr_gate<CurveType>::index() const
{
    return index_;
}

template <typename CurveType>
bool pirr_gate<CurveType>::is_start() const
{
    return position_ == position_type::start;
}
template <typename CurveType>
bool pirr_gate<CurveType>::is_end() const
{
    return position_ == position_type::end;
}

template <typename CurveType>
bool pirr_gate<CurveType>::has_challenge() const
{
    return (bool)challenge_;
}
template <typename CurveType>
const typename pirr_gate<CurveType>::ec_scalar&
pirr_gate<CurveType>::challenge() const
{
    return challenge_;
}
template <typename CurveType>
void pirr_gate<CurveType>::set_challenge(const ec_scalar& challenge)
{
    challenge_ = challenge;
}

template <typename CurveType>
void pirr_gate<CurveType>::compute_challenge()
{
    sha256_combine hasher;
    for (size_t i = 0; i < inputs_.size(); ++i)
    {
        auto input = inputs_[i];
        const auto& witnesses = input->witnesses();

        for (size_t j = 0; j < witnesses.size(); ++j)
        {
            auto witness = witnesses[j];

            bc::data_chunk data(bc::ec_compressed_size + 4 * 3);
            auto serial = bc::make_unsafe_serializer(data.begin());
            serial.write_bytes(witness.commit().point());
            serial.write_4_bytes_little_endian(i);
            serial.write_4_bytes_little_endian(j);
            serial.write_4_bytes_little_endian(index_);

            hasher.update(data);
        }
    }
    challenge_ = hasher.result();
}

template <typename CurveType>
bool pirr_gate<CurveType>::has_empty_input_witnesses() const
{
    for (const auto input: inputs_)
        if (input->has_empty_witness())
            return false;
    return true;
}

template <typename CurveType>
typename pirr_gate<CurveType>::portal_ptrlist
pirr_gate<CurveType>::inputs() const
{
    return inputs_;
}
template <typename CurveType>
typename pirr_gate<CurveType>::portal_ptrlist
pirr_gate<CurveType>::outputs() const
{
    return outputs_;
}

template <typename CurveType>
std::string pirr_gate<CurveType>::pretty(size_t indent) const
{
    auto result = std::string(indent * 4, ' ') + "gate:\n";
    result += std::string((indent + 1) * 4, ' ') + "index: " +
        std::to_string(index_) + '\n';
    if (challenge_)
        result += std::string((indent + 1) * 4, ' ') + "challenge: " +
            bc::encode_base16(challenge_.secret()) + '\n';
    if (position_ == position_type::start)
        result += std::string((indent + 1) * 4, ' ') + "is_start: true\n";
    else if (position_ == position_type::end)
        result += std::string((indent + 1) * 4, ' ') + "is_end: true\n";
    return result;
}

template <typename GatePtrType>
void link(GatePtrType start, GatePtrType end)
{
    typedef typename GatePtrType::element_type GateType;
    start->position_ = GateType::position_type::start;
    end->position_ = GateType::position_type::end;
}

template <typename GatePtrType, typename PortalPtrType>
void connect(GatePtrType start, PortalPtrType portal, GatePtrType end)
{
    portal->input_ = start;
    portal->output_ = end;
    start->outputs_.push_back(portal);
    end->inputs_.push_back(portal);
}

} // namespace libdark

#endif

