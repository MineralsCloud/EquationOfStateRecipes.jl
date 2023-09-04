module EquationOfStateRecipes

using EquationsOfStateOfSolids:
    EquationOfStateOfSolids, EnergyEquation, PressureEquation, BulkModulusEquation
using RecipesBase: plot, @userplot, @recipe, @series

import RecipesBase: recipetype

export pressurescaleplot, pressurescaleplot!

abstract type DataWrapper end
(T::Type{<:DataWrapper})(values) = T(collect(values))
struct Volumes <: DataWrapper
    values::Vector
end
struct Energies <: DataWrapper
    values::Vector
end
struct Pressures <: DataWrapper
    values::Vector
end
struct BulkModuli <: DataWrapper
    values::Vector
end

@recipe function f(::Type{Volumes}, volumes::Volumes)
    seriestype --> :path
    label --> ""
    guide --> "volume"
    return volumes.values
end
@recipe function f(::Type{Energies}, energies::Energies)
    seriestype --> :path
    label --> ""
    guide --> "energy"
    return energies.values
end
@recipe function f(::Type{Pressures}, pressures::Pressures)
    seriestype --> :path
    label --> ""
    guide --> "pressure"
    return pressures.values
end
@recipe function f(::Type{BulkModuli}, bulkmoduli::BulkModuli)
    seriestype --> :path
    label --> ""
    guide --> "bulk modulus"
    return bulkmoduli.values
end

# See https://docs.juliaplots.org/stable/recipes/#Documenting-plot-functions
"""
    plot(eos::EnergyEquation, volumes, args...; kw...)
    plot(eos::PressureEquation, volumes, args...; kw...)
    plot(eos::BulkModulusEquation, volumes, args...; kw...)
    plot!(eos::EnergyEquation, volumes, args...; kw...)
    plot!(eos::PressureEquation, volumes, args...; kw...)
    plot!(eos::BulkModulusEquation, volumes, args...; kw...)
    plot!(plotobj, eos::EnergyEquation, volumes, args...; kw...)
    plot!(plotobj, eos::PressureEquation, volumes, args...; kw...)
    plot!(plotobj, eos::BulkModulusEquation, volumes, args...; kw...)

Plot the energy/pressure/bulk modulus versus volumes curve given an equation of state.
"""
plot

@recipe function f(eos::EnergyEquation, volumes=eos.param.v0 .* (0.5:0.01:1.1))
    energies = map(eos, volumes)
    min, index = findmin(energies)
    xguide --> "volume"  # We have to add this since `Volumes` & `Energies` are not the last to return.
    yguide --> "energy"
    # We have to add the curves before the scatter, so that the labels and colors are followed correctly.
    @series begin
        seriestype --> :path
        Volumes(volumes), Energies(energies)
    end
    @series begin  # The scatter is not a primary series, so it won't be included in the legend.
        primary := false  # See https://discourse.julialang.org/t/what-does-the-primary-attribute-do-and-how-to-plot-curves-with-scatters-added-onto-it-in-plots-jl/93486/2
        seriestype --> :scatter
        markersize --> 1.25 * get(plotattributes, :linewidth, 1)
        markerstrokewidth --> 0
        label --> ""
        [volumes[index]], [min]
    end
end
@recipe function f(eos::PressureEquation, volumes=eos.param.v0 .* (0.5:0.01:1.1))
    pressures = map(eos, volumes)
    @series begin
        seriestype --> :hline
        seriescolor --> :black
        linewidth := 1  # This is an axis, don't change its width
        z_order --> :back
        label := ""
        zeros(eltype(pressures), 1)
    end
    xlims --> extrema(volumes)
    return Volumes(volumes), Pressures(pressures)
end
@recipe function f(eos::BulkModulusEquation, volumes=eos.param.v0 .* (0.5:0.01:1.1))
    bulkmoduli = map(eos, volumes)
    return Volumes(volumes), BulkModuli(bulkmoduli)
end

"""
    energyplot(params::Parameters, volumes, args...; kw...)
    energyplot!(params::Parameters, volumes, args...; kw...)
    energyplot!(plotobj, params::Parameters, volumes, args...; kw...)

Plot the energy versus volumes curves given the parameters of equations of state.
"""
@userplot EnergyPlot
@recipe function f(plot::EnergyPlot)
    params = first(plot.args)
    volumes = length(plot.args) == 2 ? last(plot.args) : params.v0 .* (0.5:0.01:1.1)
    return EnergyEquation(params), volumes
end

"""
    pressureplot(params::Parameters, volumes, args...; kw...)
    pressureplot!(params::Parameters, volumes, args...; kw...)
    pressureplot!(plotobj, params::Parameters, volumes, args...; kw...)

Plot the pressure versus volumes curves given the parameters of equations of state.
"""
@userplot PressurePlot
@recipe function f(plot::PressurePlot)
    params = first(plot.args)
    volumes = length(plot.args) == 2 ? last(plot.args) : params.v0 .* (0.5:0.01:1.1)
    return PressureEquation(params), volumes
end

"""
    bulkmodulusplot(params::Parameters, volumes, args...; kw...)
    bulkmodulusplot!(params::Parameters, volumes, args...; kw...)
    bulkmodulusplot!(plotobj, params::Parameters, volumes, args...; kw...)

Plot the bulk modulus versus volumes curves given the parameters of equations of state.
"""
@userplot BulkModulusPlot
@recipe function f(plot::BulkModulusPlot)
    params = first(plot.args)
    volumes = length(plot.args) == 2 ? last(plot.args) : params.v0 .* (0.5:0.01:1.1)
    return BulkModulusEquation(params), volumes
end

"""
    energypressureplot(params::Parameters, volumes, args...; layout=(1, 2), kw...)
    energypressureplot!(params::Parameters, volumes, args...; layout=(1, 2), kw...)
    energypressureplot!(plotobj, params::Parameters, volumes, args...; layout=(1, 2), kw...)

Create a graph that shows the energy/pressure versus volume curves using the given
parameters of equations of state on the same horizontal axis.

!!! warning
    To use this function, you must specify the `layout` keyword argument as either
    `(1, 2)` or `(2, 1)`!
"""
@userplot EnergyPressurePlot
@recipe function f(plot::EnergyPressurePlot)
    params = first(plot.args)
    volumes = length(plot.args) == 2 ? last(plot.args) : params.v0 .* (0.5:0.01:1.1)
    @series begin
        title --> raw"$E(V)$"
        subplot := 1
        recipetype(:energyplot, params, volumes)
    end
    @series begin
        title --> raw"$P(V)$"
        subplot := 2
        recipetype(:pressureplot, params, volumes)
    end
end

function pressurescaleplot end
function pressurescaleplot! end

# See https://github.com/JuliaPlots/StatsPlots.jl/blob/v0.15.6/src/bar.jl#L3
recipetype(::Val{:energyplot}, args...) = EnergyPlot(args)
recipetype(::Val{:pressureplot}, args...) = PressurePlot(args)
recipetype(::Val{:bulkmodulusplot}, args...) = BulkModulusPlot(args)
recipetype(::Val{:energypressureplot}, args...) = EnergyPressurePlot(args)

end
