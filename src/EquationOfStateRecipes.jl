module EquationOfStateRecipes

using EquationsOfStateOfSolids:
    EquationOfStateOfSolids, EnergyEquation, PressureEquation, BulkModulusEquation
using RecipesBase: @userplot, @recipe, @series, grid
using Unitful: AbstractQuantity, DimensionError, unit, uconvert, dimension, @u_str

struct Volumes{T}
    values::Vector{T}
end

struct Energies{T}
    values::Vector{T}
end

struct Pressures{T}
    values::Vector{T}
end

struct BulkModuli{T}
    values::Vector{T}
end

@recipe f(::Type{Volumes}, 𝐕::Volumes) = 𝐕.values
@recipe f(::Type{Energies}, 𝐄::Energies) = 𝐄.values
@recipe f(::Type{Pressures}, 𝐏::Pressures) = 𝐏.values
@recipe f(::Type{BulkModuli}, 𝐁::BulkModuli) = 𝐁.values

@recipe function f(
    eos::EquationOfStateOfSolids,
    volumes=eos.param.v0 .* (0.5:0.01:1.1);
    xunit=u"angstrom^3",
    yunit=u"GPa",
)
    xguide --> "volume"
    yguide --> _yguide(eos)
    framestyle --> :box
    xlims --> extrema(volumes)
    legend_foreground_color --> nothing
    grid --> nothing
    yvalues = map(eos, volumes)
    x, y = if eltype(volumes) <: AbstractQuantity && eltype(yvalues) <: AbstractQuantity
        if dimension(xunit) != dimension(eltype(volumes)) ||
            dimension(yunit) != dimension(eltype(yvalues))
            error("")
        else
            uconvert.(xunit, volumes), uconvert.(yunit, yvalues)
        end
    elseif eltype(volumes) <: Real && eltype(yvalues) <: Real
        volumes, map(eos, volumes)
    else
        error("")
    end
    if eos isa PressureEquation
        @series begin
            seriestype --> :hline
            seriescolor := :black
            z_order --> :back
            primary := false
            label --> ""
            zeros(eltype(y), 1)
        end
    end
    @series begin
        seriestype --> :scatter
        markersize --> 2
        markerstrokecolor --> :auto
        markerstrokewidth --> 0
        primary := false
        x, y
    end
    seriestype --> :path
    label --> ""
    return x, y
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

_yguide(::EnergyEquation) = "energy"
_yguide(::PressureEquation) = "pressure"
_yguide(::BulkModulusEquation) = "bulk modulus"

end
