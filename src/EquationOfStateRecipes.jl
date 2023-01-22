module EquationOfStateRecipes

using EquationsOfStateOfSolids:
    EquationOfStateOfSolids, EnergyEquation, PressureEquation, BulkModulusEquation
using RecipesBase: @userplot, @recipe, @series
using Unitful: AbstractQuantity, uconvert, @u_str

@recipe function f(
    eos::EquationOfStateOfSolids,
    volumes=eos.param.v0 .* (0.5:0.01:1.1);
    xunit=u"angstrom^3",
    yunit=u"GPa"
)
    xguide --> "volume"
    yguide --> _yguide(eos)
    framestyle --> :box
    xlims --> extrema(volumes)
    legend_foreground_color --> nothing
    grid --> nothing
    yvalues = map(eos, volumes)
    x, y = if eltype(volumes) <: AbstractQuantity && eltype(yvalues) <: AbstractQuantity
        uconvert.(xunit, volumes), uconvert.(yunit, yvalues)
    elseif eltype(volumes) <: Real && eltype(yvalues) <: Real
        volumes, map(eos, volumes)
    else
        throw(DomainError(""))
    end
    if eos isa PressureEquation
        @series begin
            seriestype --> :hline
            seriescolor := :black
            z_order --> :back
            primary := false
            label --> ""
            zeros(eltype(x), 1)
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
    EnergyEquation(params), volumes
end

@userplot PressurePlot
@recipe function f(plot::PressurePlot)
    params = first(plot.args)
    volumes = length(plot.args) == 2 ? plot.args[end] : params.v0 .* (0.5:0.01:1.1)
    PressureEquation(params), volumes
end

@userplot BulkModulusPlot
@recipe function f(plot::BulkModulusPlot)
    params = first(plot.args)
    volumes = length(plot.args) == 2 ? plot.args[end] : params.v0 .* (0.5:0.01:1.1)
    BulkModulusEquation(params), volumes
end

_yguide(::EnergyEquation) = "energy"
_yguide(::PressureEquation) = "pressure"
_yguide(::BulkModulusEquation) = "bulk modulus"

_ydefaultunit(::EnergyEquation) = u"eV"
_ydefaultunit(::PressureEquation) = u"GPa"
_ydefaultunit(::BulkModulusEquation) = u"GPa"

end
