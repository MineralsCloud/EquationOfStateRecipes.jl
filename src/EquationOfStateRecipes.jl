module EquationOfStateRecipes

using EquationsOfStateOfSolids:
    EquationOfStateOfSolids, EnergyEquation, PressureEquation, BulkModulusEquation
using RecipesBase: @userplot, @recipe, @series
using Unitful: AbstractQuantity, ustrip, @u_str

import RecipesBase

@recipe function f(
    eos::EquationOfStateOfSolids,
    volumes=eos.param.v0 .* (0.5:0.01:1.1)
)
    xguide --> "volume"
    yguide --> _yguide(eos)
    frame --> :box
    xlims --> extrema(volumes)
    legend_foreground_color --> nothing
    grid --> nothing
    if eos isa PressureEquation
        @series begin
            seriestype --> :hline
            seriescolor := :black
            z_order --> :back
            primary := false
            label --> ""
            Base.vect(0)
        end
    end
    @series begin
        seriestype --> :scatter
        markersize --> 2
        markerstrokecolor --> :auto
        markerstrokewidth --> 0
        primary := false
        volumes, map(eos, volumes)
    end
    seriestype --> :path
    return volumes, map(eos, volumes)
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
