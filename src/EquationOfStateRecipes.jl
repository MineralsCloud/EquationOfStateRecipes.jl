module EquationOfStateRecipes

using EquationsOfStateOfSolids.Collections:
    EquationOfStateOfSolids, EnergyEOS, PressureEOS, BulkModulusEOS
using RecipesBase: @recipe
using Unitful: ustrip

import RecipesBase

@recipe function f(
    eos::EquationOfStateOfSolids,
    volumes::AbstractVector = (0.5:0.01:1.1) * eos.param.v0,
)
    xguide --> "volume"
    yguide --> _yprefix(typeof(eos))
    return map(ustrip, volumes), map(ustrip ∘ eos, volumes)
end

_yprefix(::Type{<:EnergyEOS}) = "energy"
_yprefix(::Type{<:PressureEOS}) = "pressure"
_yprefix(::Type{<:BulkModulusEOS}) = "bulk modulus"

end
