module EquationOfStateRecipes

using EquationsOfStateOfSolids.Collections:
    EquationOfStateOfSolids, EnergyEOS, PressureEOS, BulkModulusEOS
using RecipesBase: @recipe
using Unitful: AbstractQuantity, ustrip, @u_str

import RecipesBase

@recipe function f(
    eos::EquationOfStateOfSolids,
    volumes::AbstractVector = (0.5:0.01:1.1) * eos.param.v0,
)
    if eltype(volumes) <: AbstractQuantity
        u = _yunit(typeof(eos))
        xguide --> "volume (angstrom^3)"
        yguide --> _yprefix(typeof(eos)) * " ($u)"
        x = map(Base.Fix1(ustrip, u"angstrom^3"), volumes)
        y = map(Base.Fix1(ustrip, u) ∘ eos, volumes)
        return x, y
    else
        xguide --> "volume"
        yguide --> _yprefix(typeof(eos))
        return volumes, map(eos, volumes)
    end
end

_yprefix(::Type{<:EnergyEOS}) = "energy"
_yprefix(::Type{<:PressureEOS}) = "pressure"
_yprefix(::Type{<:BulkModulusEOS}) = "bulk modulus"

_yunit(::Type{<:EnergyEOS}) = u"eV"
_yunit(::Type{<:PressureEOS}) = u"GPa"
_yunit(::Type{<:BulkModulusEOS}) = u"GPa"

end
