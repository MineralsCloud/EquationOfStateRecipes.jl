module EquationOfStateRecipes

using EquationsOfStateOfSolids: EnergyEquation, PressureEquation, BulkModulusEquation
using RecipesBase: @userplot, @recipe, @series, grid

abstract type Data end
(T::Type{<:Data})(values) = T(collect(values))
struct Volumes <: Data
    values::Vector
end
struct Energies <: Data
    values::Vector
end
struct Pressures <: Data
    values::Vector
end
struct BulkModuli <: Data
    values::Vector
end

@recipe function f(::Type{Volumes}, volumes::Volumes)
    seriestype --> :path
    markershape --> :circle
    markersize --> 2
    markerstrokecolor --> :auto
    markerstrokewidth --> 0
    guide --> "volume"
    return volumes.values
end
@recipe function f(::Type{Energies}, energies::Energies)
    seriestype --> :path
    markershape --> :circle
    markersize --> 2
    markerstrokecolor --> :auto
    markerstrokewidth --> 0
    guide --> "energy"
    return energies.values
end
@recipe function f(::Type{Pressures}, pressures::Pressures)
    seriestype --> :path
    markershape --> :circle
    markersize --> 2
    markerstrokecolor --> :auto
    markerstrokewidth --> 0
    guide --> "pressure"
    return pressures.values
end
@recipe function f(::Type{BulkModuli}, bulkmoduli::BulkModuli)
    seriestype --> :path
    markershape --> :circle
    markersize --> 2
    markerstrokecolor --> :auto
    markerstrokewidth --> 0
    guide --> "bulk modulus"
    return bulkmoduli.values
end

@recipe function f(eos::EnergyEquation, volumes=eos.param.v0 .* (0.5:0.01:1.1))
    energies = map(eos, volumes)
    framestyle --> :box
    xlims --> extrema(volumes)
    ylims --> extrema(energies)
    legend_foreground_color --> nothing
    grid --> nothing
    return Volumes(volumes), Energies(energies)
end
@recipe function f(eos::PressureEquation, volumes=eos.param.v0 .* (0.5:0.01:1.1))
    pressures = map(eos, volumes)
    framestyle --> :box
    xlims --> extrema(volumes)
    ylims --> extrema(pressures)
    legend_foreground_color --> nothing
    grid --> nothing
    @series begin
        seriestype --> :hline
        seriescolor --> :black
        z_order --> :back
        label := ""
        zeros(eltype(pressures), 1)
    end
    return Volumes(volumes), Pressures(pressures)
end
@recipe function f(eos::BulkModulusEquation, volumes=eos.param.v0 .* (0.5:0.01:1.1))
    bulkmoduli = map(eos, volumes)
    framestyle --> :box
    xlims --> extrema(volumes)
    ylims --> extrema(bulkmoduli)
    legend_foreground_color --> nothing
    grid --> nothing
    return Volumes(volumes), BulkModuli(bulkmoduli)
end

@userplot EnergyPlot
@recipe function f(plot::EnergyPlot)
    params = first(plot.args)
    volumes = length(plot.args) == 2 ? plot.args[end] : params.v0 .* (0.5:0.01:1.1)
    return EnergyEquation(params), volumes
end
"""
    energyplot(params, volumes, args...; kw...)
    energyplot!(params, volumes, args...; kw...)
    energyplot!(plotobj, params, volumes, args...; kw...)

Plot the energy versus volumes curves given the parameters of equations of state.
"""
energyplot

@userplot PressurePlot
@recipe function f(plot::PressurePlot)
    params = first(plot.args)
    volumes = length(plot.args) == 2 ? plot.args[end] : params.v0 .* (0.5:0.01:1.1)
    return PressureEquation(params), volumes
end
"""
    pressureplot(params, volumes, args...; kw...)
    pressureplot!(params, volumes, args...; kw...)
    pressureplot!(plotobj, params, volumes, args...; kw...)

Plot the pressure versus volumes curves given the parameters of equations of state.
"""
pressureplot

@userplot BulkModulusPlot
@recipe function f(plot::BulkModulusPlot)
    params = first(plot.args)
    volumes = length(plot.args) == 2 ? plot.args[end] : params.v0 .* (0.5:0.01:1.1)
    return BulkModulusEquation(params), volumes
end
"""
    bulkmodulusplot(params, volumes, args...; kw...)
    bulkmodulusplot!(params, volumes, args...; kw...)
    bulkmodulusplot!(plotobj, params, volumes, args...; kw...)

Plot the bulk modulus versus volumes curves given the parameters of equations of state.
"""
bulkmodulusplot

@userplot DualPlot
@recipe function f(plot::DualPlot)
    params = first(plot.args)
    volumes = length(plot.args) == 2 ? plot.args[end] : params.v0 .* (0.5:0.01:1.1)
    framestyle --> :box
    xlims --> extrema(volumes)
    label --> ""
    legend_foreground_color --> nothing
    grid --> nothing
    layout := grid(2, 1)
    @series begin
        eos = EnergyEquation(params)
        energies = map(eos, volumes)
        ylims --> extrema(energies)
        title --> raw"$E(V)$"
        xguide := ""
        subplot := 1
        Volumes(volumes), Energies(energies)
    end
    @series begin
        eos = PressureEquation(params)
        pressures = map(eos, volumes)
        ylims --> extrema(pressures)
        title --> raw"$P(V)$"
        subplot := 2
        Volumes(volumes), Pressures(pressures)
    end
end
"""
    dualplot(params, volumes, args...; kw...)
    dualplot!(params, volumes, args...; kw...)
    dualplot!(plotobj, params, volumes, args...; kw...)

Create a graph that shows the energy/pressure versus volume curves using the given 
parameters of equations of state on the same horizontal axis.
"""
dualplot

end
