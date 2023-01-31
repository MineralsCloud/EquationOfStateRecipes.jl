module EquationOfStateRecipes

using EquationsOfStateOfSolids:
    EquationOfStateOfSolids, EnergyEquation, PressureEquation, BulkModulusEquation
using RecipesBase: @userplot, @recipe, @series, grid
using Unitful: AbstractQuantity, DimensionError, unit, uconvert, dimension, @u_str

export Volumes, Energies, Pressures, BulkModuli

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

@userplot PressurePlot
@recipe function f(plot::PressurePlot)
    params = first(plot.args)
    volumes = length(plot.args) == 2 ? plot.args[end] : params.v0 .* (0.5:0.01:1.1)
    return PressureEquation(params), volumes
end

@userplot BulkModulusPlot
@recipe function f(plot::BulkModulusPlot)
    params = first(plot.args)
    volumes = length(plot.args) == 2 ? plot.args[end] : params.v0 .* (0.5:0.01:1.1)
    return BulkModulusEquation(params), volumes
end

@userplot EOSPlot
@recipe function f(plot::EOSPlot)
    params = first(plot.args)
    volumes = length(plot.args) == 2 ? plot.args[end] : params.v0 .* (0.5:0.01:1.1)
    link := :x
    layout := grid(2, 1)
    @series begin
        eos = EnergyEquation(params)
        yvalues = map(eos, volumes)
        title --> raw"$E(V)$"
        subplot := 1
        volumes, yvalues
    end
    @series begin
        eos = PressureEquation(params)
        yvalues = map(eos, volumes)
        title --> raw"$P(V)$"
        subplot := 2
        volumes, yvalues
    end
end

end
