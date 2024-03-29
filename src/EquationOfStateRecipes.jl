module EquationOfStateRecipes

using EquationsOfStateOfSolids: EnergyEquation, PressureEquation, BulkModulusEquation
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
    return Volumes(volumes), Energies(energies)
end
@recipe function f(eos::PressureEquation, volumes=eos.param.v0 .* (0.5:0.01:1.1))
    pressures = map(eos, volumes)
    @series begin
        seriestype --> :hline
        seriescolor := :black  # Fix the axis color
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

function pressurescaleplot end
function pressurescaleplot! end

# See https://github.com/JuliaPlots/StatsPlots.jl/blob/v0.15.6/src/bar.jl#L3
recipetype(::Val{:energyplot}, args...) = EnergyPlot(args)
recipetype(::Val{:pressureplot}, args...) = PressurePlot(args)
recipetype(::Val{:bulkmodulusplot}, args...) = BulkModulusPlot(args)

end
