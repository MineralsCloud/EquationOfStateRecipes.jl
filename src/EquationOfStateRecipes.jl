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

@recipe function f(::Type{Volumes{T}}, volumes::Volumes{T}) where {T}
    seriestype --> :path
    markershape --> :circle
    markersize --> 2
    markerstrokecolor --> :auto
    markerstrokewidth --> 0
    guide --> "volume"
    return volumes
end
@recipe function f(::Type{Energies{T}}, energies::Energies{T}) where {T}
    seriestype --> :path
    markershape --> :circle
    markersize --> 2
    markerstrokecolor --> :auto
    markerstrokewidth --> 0
    guide --> "energy"
    return energies
end
@recipe function f(::Type{Pressures{T}}, pressures::Pressures{T}) where {T}
    seriestype --> :path
    markershape --> :circle
    markersize --> 2
    markerstrokecolor --> :auto
    markerstrokewidth --> 0
    guide --> "pressure"
    return pressures
end
@recipe function f(::Type{BulkModuli{T}}, bulkmoduli::BulkModuli{T}) where {T}
    seriestype --> :path
    markershape --> :circle
    markersize --> 2
    markerstrokecolor --> :auto
    markerstrokewidth --> 0
    guide --> "bulk modulus"
    return bulkmoduli
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

Base.size(data::Data) = size(data.values)

Base.IndexStyle(::Type{<:Data}) = IndexLinear()

Base.getindex(data::Data, i) = getindex(data.values, i)

Base.setindex!(data::Data, value, i) = getindex(data.values, value, i)

end
