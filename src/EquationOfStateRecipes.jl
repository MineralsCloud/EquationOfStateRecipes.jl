module EquationOfStateRecipes

using EquationsOfStateOfSolids:
    EquationOfStateOfSolids, EnergyEquation, PressureEquation, BulkModulusEquation
using RecipesBase: @userplot, @recipe, @series, grid
using Unitful: AbstractQuantity, DimensionError, unit, uconvert, dimension, @u_str

export Volumes, Energies, Pressures, BulkModuli

abstract type IndependentVariable{T} end
struct Volumes{T} <: IndependentVariable{T}
    values::Vector{T}
end
abstract type DependentVariable{T} end
struct Energies{T} <: DependentVariable{T}
    values::Vector{T}
end
struct Pressures{T} <: DependentVariable{T}
    values::Vector{T}
end
struct BulkModuli{T} <: DependentVariable{T}
    values::Vector{T}
end

@recipe function f(::Type{Volumes{T}}, volumes::Volumes) where {T}
    xguide --> "volume"
    xlims --> extrema(volumes.values)
    return volumes.values
end
@recipe function f(::Type{Energies{T}}, energies::Energies{T}) where {T}
    yguide --> "energy"
    @series begin
        seriestype --> :scatter
        markersize --> 2
        markerstrokecolor --> :auto
        markerstrokewidth --> 0
        primary := false
        energies.values
    end
    seriestype --> :path
    label --> ""
    return energies.values
end
@recipe function f(::Type{Pressures{T}}, pressures::Pressures{T}) where {T}
    yguide --> "pressure"
    @series begin
        seriestype --> :hline
        seriescolor := :black
        z_order --> :back
        primary := false
        zeros(T, 1)
    end
    @series begin
        seriestype --> :scatter
        markersize --> 2
        markerstrokecolor --> :auto
        markerstrokewidth --> 0
        primary := false
        pressures.values
    end
    seriestype --> :path
    label --> ""
    return pressures.values
end
@recipe function f(::Type{BulkModuli{T}}, bulkmoduli::BulkModuli{T}) where {T}
    yguide --> "bulk modulus"
    @series begin
        seriestype --> :scatter
        markersize --> 2
        markerstrokecolor --> :auto
        markerstrokewidth --> 0
        primary := false
        bulkmoduli.values
    end
    seriestype --> :path
    label --> ""
    return bulkmoduli.values
end

@recipe function f(eos::EquationOfStateOfSolids, volumes=eos.param.v0 .* (0.5:0.01:1.1))
    framestyle --> :box
    xlims --> extrema(volumes)
    legend_foreground_color --> nothing
    grid --> nothing
    yvalues = map(eos, volumes)
    return volumes, yvalues
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
