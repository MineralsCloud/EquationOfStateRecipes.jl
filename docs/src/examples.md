# Examples

Here are one example of plotting four equations of state in one figure with
energy and pressure versus volume.

```@example 1
using EquationOfStateRecipes
using EquationsOfStateOfSolids
using Plots

bm = BirchMurnaghan3rd(40.989265727926536, 0.5369258245609575, 4.178644231927682, -10.8428039082991)
m = Murnaghan1st(41.13757924604193, 0.5144967654094419, 3.9123863221667086, -10.836794510844241)
pt = PoirierTarantola3rd(40.86770643567071, 0.5667729960008748, 4.331688934947504, -10.851486685029437)
v = Vinet(40.9168756740098, 0.5493839427843088, 4.3051929493806345, -10.846160810983498)

dualplot(bm; label="Birch–Murnaghan");
dualplot!(m; label="Murnaghan");
dualplot!(pt; label="Poirier–Tarantola");
dualplot!(v; label="Vinet");
savefig("plot.svg"); nothing # hide
```

![](plot.svg)

We can add units to these equations of state without any difficulty:

```@example 1
using Unitful, UnitfulAtomic

bm = BirchMurnaghan3rd(40.989265727926536u"angstrom^3", 0.5369258245609575u"Ry/angstrom^3", 4.178644231927682, -10.8428039082991u"Ry")
m = Murnaghan1st(41.13757924604193u"angstrom^3", 0.5144967654094419u"Ry/angstrom^3", 3.9123863221667086, -10.836794510844241u"Ry")
pt = PoirierTarantola3rd(40.86770643567071u"angstrom^3", 0.5667729960008748u"Ry/angstrom^3", 4.331688934947504, -10.851486685029437u"Ry")
v = Vinet(40.9168756740098u"angstrom^3", 0.5493839427843088u"Ry/angstrom^3", 4.3051929493806345, -10.846160810983498u"Ry")

dualplot(bm; label="Birch–Murnaghan");
dualplot!(m; label="Murnaghan");
dualplot!(pt; label="Poirier–Tarantola");
dualplot!(v; label="Vinet");
savefig("plot_with_units.svg"); nothing # hide
```

![](plot_with_units.svg)
