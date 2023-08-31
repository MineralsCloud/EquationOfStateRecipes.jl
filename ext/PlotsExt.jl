module PlotsExt

using RecipesBase: AbstractPlot, plot, plot!
using EquationsOfStateOfSolids: EquationOfStateOfSolids, PressureEquation
using Plots: xticks, twiny, yticks

import EquationOfStateRecipes: pressurescaleplot, pressurescaleplot!

function pressurescaleplot!(
    p::AbstractPlot, eos::EquationOfStateOfSolids, volumes=eos.param.v0 .* (0.5:0.01:1.1)
)
    pressures = map(PressureEquation(eos), volumes)
    plot!(eos, volumes)
    p1, p2 = extrema(pressures)
    axis2 = range(p1, p2; length=length(first(first(xticks(p)))))
    plot!(twiny(p), [], []; label="", xlims=(p1, p2), xticks=axis2, xaxis="pressure")
    plot!(p; framestyle=:box)
    return p
end
pressurescaleplot!(eos::EquationOfStateOfSolids, volumes=eos.param.v0 .* (0.5:0.01:1.1)) =
    pressurescaleplot!(plot(), eos, volumes)
pressurescaleplot(eos::EquationOfStateOfSolids, volumes=eos.param.v0 .* (0.5:0.01:1.1)) =
    pressurescaleplot!(plot(), eos, volumes)

end
