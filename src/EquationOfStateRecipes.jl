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
        u = _ydefaultunit(typeof(eos))
        xguide --> "volume"
        yguide --> _yguideprefix(eos) * " ($u)"
        x = map(Base.Fix1(ustrip, u"angstrom^3"), volumes)
        y = map(Base.Fix1(ustrip, u) ∘ eos, volumes)
        return x, y
    else
        xguide --> "volume"
        yguide --> _yguideprefix(eos)
        return volumes, map(eos, volumes)
    end
end

_yguideprefix(::EnergyEquation) = "energy"
_yguideprefix(::PressureEquation) = "pressure"
_yguideprefix(::BulkModulusEquation) = "bulk modulus"

_ydefaultunit(::EnergyEquation) = u"eV"
_ydefaultunit(::PressureEquation) = u"GPa"
_ydefaultunit(::BulkModulusEquation) = u"GPa"

end
