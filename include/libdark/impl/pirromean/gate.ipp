#ifndef LIBDARK_PIRROMEAN_GATE_IPP
#define LIBDARK_PIRROMEAN_GATE_IPP

namespace libdark {

template <typename CurveType>
pirr_gate<CurveType>::pirr_gate(size_t index)
  : index_(index)
{
}

template <typename CurveType>
pirr_gate<CurveType> pirr_gate<CurveType>::clone_public() const
{
    return pirr_gate<CurveType>(index_);
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
const typename pirr_gate<CurveType>::ec_scalar&
pirr_gate<CurveType>::challenge() const
{
    return challenge_;
}

template <typename CurveType>
typename pirr_gate<CurveType>::portal_ptrlist
pirr_gate<CurveType>::inputs() const
{
    return inputs_;
}

template <typename CurveType>
std::string pirr_gate<CurveType>::pretty(size_t indent) const
{
    return "";
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

