# Examples

```@contents
Pages = ["examples.md"]
Depth = 2
```

Here is an example of plotting four equations of state in one figure with energy and
pressure versus volume.

We can plot these parameters directly using shorthand functions such as `energyplot`, `pressureplot`, `bulkmodulusplot`:

```@repl 1
using EquationOfStateRecipes
using EquationsOfStateOfSolids
using Plots

bm = BirchMurnaghan3rd(40.989265727926536, 0.5369258245609575, 4.178644231927682, -10.8428039082991);
m = Murnaghan1st(41.13757924604193, 0.5144967654094419, 3.9123863221667086, -10.836794510844241);
pt = PoirierTarantola3rd(40.86770643567071, 0.5667729960008748, 4.331688934947504, -10.851486685029437);
v = Vinet(40.9168756740098, 0.5493839427843088, 4.3051929493806345, -10.846160810983498);

plot(; legend=true);
bulkmodulusplot!(bm; label="Birch–Murnaghan");
bulkmodulusplot!(bm; label="Murnaghan");
bulkmodulusplot!(pt; label="Poirier–Tarantola");
bulkmodulusplot!(v; label="Vinet");
title!(raw"$B(V)$");
savefig("bv.svg"); nothing # hide
```

![](bv.svg)

Of course, we can construct four equations of state from those parameters and `plot` them:

```@repl 1
bmeos = EnergyEquation(bm);
meos = EnergyEquation(m);
pteos = EnergyEquation(pt);
veos = EnergyEquation(v);

plot(; legend=true);
plot!(bmeos; label="Birch–Murnaghan");
plot!(meos; label="Murnaghan");
plot!(pteos; label="Poirier–Tarantola");
plot!(veos; label="Vinet");
title!(raw"$E(V)$");
savefig("eos.svg"); nothing # hide
```

![](eos.svg)

Or, we can plot subplots with:

```@repl 1
colors = palette(:tab10)
labels = ["Birch–Murnaghan", "Murnaghan", "Poirier–Tarantola", "Vinet"]
plt = plot(; layout=(1, 2))
for (params, label, color) in zip((bm, m, pt, v), labels, colors)
    energyplot!(plt, params; label=label, subplot=1, color=color);
    pressureplot!(plt, params; label=label, subplot=2, color=color);
end
savefig(plt, "energypressureplot.svg"); nothing # hide
```

![](energypressureplot.svg)

Also, we can add units to these equations of state without any difficulty:

```@repl 1
using Unitful, UnitfulAtomic

bm = BirchMurnaghan3rd(40.989265727926536u"angstrom^3", 0.5369258245609575u"Ry/angstrom^3", 4.178644231927682, -10.8428039082991u"Ry");
m = Murnaghan1st(41.13757924604193u"angstrom^3", 0.5144967654094419u"Ry/angstrom^3", 3.9123863221667086, -10.836794510844241u"Ry");
pt = PoirierTarantola3rd(40.86770643567071u"angstrom^3", 0.5667729960008748u"Ry/angstrom^3", 4.331688934947504, -10.851486685029437u"Ry");
v = Vinet(40.9168756740098u"angstrom^3", 0.5493839427843088u"Ry/angstrom^3", 4.3051929493806345, -10.846160810983498u"Ry");

plt = plot(energyplot(bm; label="Birch–Murnaghan", yunit=u"Ry"), pressureplot(bm; label="Birch–Murnaghan", yunit=u"GPa"))
for (params, label, color) in zip((m, pt, v), labels, colors)
    energyplot!(plt, params; label=label, subplot=1, color=color);
    pressureplot!(plt, params; label=label, subplot=2, color=color);
end
savefig(plt, "units.svg"); nothing # hide
```

![](units.svg)
