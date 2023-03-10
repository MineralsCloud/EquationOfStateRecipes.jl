module EquationOfStateRecipes

using EquationsOfStateOfSolids:
    EquationOfStateOfSolids,
    EnergyEquation,
    PressureEquation,
    BulkModulusEquation,
    Parameters
using RecipesBase: plot, @userplot, @recipe, @series

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
    framestyle --> :box
    lims --> extrema(volumes.values)
    seriestype --> :path
    guide --> "volume"
    legend_foreground_color --> nothing
    return volumes.values
end
@recipe function f(::Type{Energies}, energies::Energies)
    framestyle --> :box
    lims --> extrema(energies.values)
    seriestype --> :path
    guide --> "energy"
    legend_foreground_color --> nothing
    return energies.values
end
@recipe function f(::Type{Pressures}, pressures::Pressures)
    framestyle --> :box
    lims --> extrema(pressures.values)
    seriestype --> :path
    guide --> "pressure"
    legend_foreground_color --> nothing
    return pressures.values
end
@recipe function f(::Type{BulkModuli}, bulkmoduli::BulkModuli)
    framestyle --> :box
    lims --> extrema(bulkmoduli.values)
    seriestype --> :path
    guide --> "bulk modulus"
    legend_foreground_color --> nothing
    return bulkmoduli.values
end

@recipe function f(eos::EnergyEquation, volumes=eos.param.v0 .* (0.5:0.01:1.1))
    energies = map(eos, volumes)
    grid --> false
    return Volumes(volumes), Energies(energies)
end
@recipe function f(eos::PressureEquation, volumes=eos.param.v0 .* (0.5:0.01:1.1))
    pressures = map(eos, volumes)
    grid --> false
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
    grid --> false
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
    volumes = length(plot.args) == 2 ? plot.args[end] : params.v0 .* (0.5:0.01:1.1)
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
    volumes = length(plot.args) == 2 ? plot.args[end] : params.v0 .* (0.5:0.01:1.1)
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
    volumes = length(plot.args) == 2 ? plot.args[end] : params.v0 .* (0.5:0.01:1.1)
    return BulkModulusEquation(params), volumes
end

"""
    dualplot(params::Parameters, volumes, args...; kw...)
    dualplot!(params::Parameters, volumes, args...; kw...)
    dualplot!(plotobj, params::Parameters, volumes, args...; kw...)

Create a graph that shows the energy/pressure versus volume curves using the given 
parameters of equations of state on the same horizontal axis.
"""
@userplot DualPlot
@recipe function f(plot::DualPlot)
    params = first(plot.args)
    volumes = length(plot.args) == 2 ? plot.args[end] : params.v0 .* (0.5:0.01:1.1)
    label --> ""
    grid --> false
    layout := (2, 1)
    @series begin
        eos = EnergyEquation(params)
        energies = map(eos, volumes)
        title --> raw"$E(V)$"
        xguide := ""
        subplot := 1
        Volumes(volumes), Energies(energies)
    end
    @series begin
        eos = PressureEquation(params)
        pressures = map(eos, volumes)
        title --> raw"$P(V)$"
        subplot := 2
        @series begin
            seriestype --> :hline
            seriescolor --> :black
            z_order --> :back
            label := ""
            zeros(eltype(pressures), 1)
        end
        Volumes(volumes), Pressures(pressures)
    end
end

"""
    plot(eos::EquationOfStateOfSolids, volumes, args...; kw...)
    plot!(eos::EquationOfStateOfSolids, volumes, args...; kw...)
    plot!(plotobj, eos::EquationOfStateOfSolids, volumes, args...; kw...)

Plot the property versus volumes curves given an equation of state.
"""
plot

end
