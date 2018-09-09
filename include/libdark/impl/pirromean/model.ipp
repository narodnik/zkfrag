#ifndef LIBDARK_PIRROMEAN_MODEL_IPP
#define LIBDARK_PIRROMEAN_MODEL_IPP

namespace libdark {

template <typename CurveType>
pirr_model<CurveType>::pirr_model(gate_ptrlist gates, portal_ptrlist portals)
  : gates_(gates), portals_(portals)
{
}

template <typename CurveType>
typename pirr_model<CurveType>::gate_ptr
pirr_model<CurveType>::start_gate() const
{
    for (auto gate: gates_)
        if (gate->is_start())
            return gate;
    return nullptr;
}
template <typename CurveType>
typename pirr_model<CurveType>::gate_ptr
pirr_model<CurveType>::end_gate() const
{
    for (auto gate: gates_)
        if (gate->is_end())
            return gate;
    return nullptr;
}

template <typename CurveType>
void pirr_model<CurveType>::sign()
{
    auto end = end_gate();
    get_challenge(end);
}

template <typename CurveType>
void pirr_model<CurveType>::get_challenge(gate_ptr gate) const
{
    if (gate->challenge())
        return;
    // TODO: sort this out, "invalid graph"
    if (gate->is_start())
        throw;
    //for (
}

template <typename CurveType>
bool pirr_model<CurveType>::verify() const
{
    return true;
}

} // namespace libdark

#endif

