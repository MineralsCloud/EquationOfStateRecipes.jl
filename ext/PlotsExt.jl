module PlotsExt

using RecipesBase: AbstractPlot, plot, plot!
using EquationsOfStateOfSolids: EquationOfStateOfSolids, PressureEquation
using Plots: current, xticks, twiny, yticks

import EquationOfStateRecipes: pressurescaleplot, pressurescaleplot!

function pressurescaleplot!(
    plt::AbstractPlot, eos::EquationOfStateOfSolids, volumes=eos.param.v0 .* (0.5:0.01:1.1)
)
    pressures = map(PressureEquation(eos), volumes)
    plot!(eos, volumes)
    pₘᵢₙ, pₘₐₓ = extrema(pressures)
    xaxis₂ = range(pₘᵢₙ, pₘₐₓ; length=length(first(first(xticks(plt)))))
    plot!(twiny(plt), [], []; label="", xlims=(pₘᵢₙ, pₘₐₓ), xticks=xaxis₂, xaxis="pressure")
    plot!(plt; framestyle=:box)
    return plt
end
pressurescaleplot!(eos::EquationOfStateOfSolids, volumes=eos.param.v0 .* (0.5:0.01:1.1)) =
    pressurescaleplot!(current(), eos, volumes)
pressurescaleplot(eos::EquationOfStateOfSolids, volumes=eos.param.v0 .* (0.5:0.01:1.1)) =
    pressurescaleplot!(plot(), eos, volumes)

end
