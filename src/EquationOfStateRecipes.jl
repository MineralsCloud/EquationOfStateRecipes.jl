module EquationOfStateRecipes

using EquationsOfStateOfSolids.Collections: EnergyEOS, PressureEOS, BulkModulusEOS
using RecipesBase
using Unitful: ustrip

@recipe function f(eos::EnergyEOS, volumes::AbstractVector = (0.5:0.01:1.1) * eos.param.v0)
    xlabel --> "volume"
    yguide --> "energy"
    markershape --> :diamond
    return map(ustrip, volumes), map(ustrip ∘ eos, volumes)
end

end
