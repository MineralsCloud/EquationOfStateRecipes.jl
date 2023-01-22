module EquationOfStateRecipes

using EquationsOfStateOfSolids:
    EquationOfStateOfSolids, EnergyEquation, PressureEquation, BulkModulusEquation
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
        yguide --> _yguideprefix(typeof(eos))
        return volumes, map(eos, volumes)
    end
end

_yguideprefix(::Type{<:EnergyEquation}) = "energy"
_yguideprefix(::Type{<:PressureEquation}) = "pressure"
_yguideprefix(::Type{<:BulkModulusEquation}) = "bulk modulus"

_ydefaultunit(::Type{<:EnergyEquation}) = u"eV"
_ydefaultunit(::Type{<:PressureEquation}) = u"GPa"
_ydefaultunit(::Type{<:BulkModulusEquation}) = u"GPa"

end
