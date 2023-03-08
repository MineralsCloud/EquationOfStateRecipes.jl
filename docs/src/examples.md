# Examples

Here are one example of plotting four equations of state in one figure with
energy and pressure versus volume.

```@example
bm = BirchMurnaghan3rd(40.989265727926536, 0.5369258245609575, 4.178644231927682, -10.8428039082991)
m = Murnaghan1st(41.13757924604193, 0.5144967654094419, 3.9123863221667086, -10.836794510844241)
pt = PoirierTarantola3rd(40.86770643567071, 0.5667729960008748, 4.331688934947504, -10.851486685029437)
v = Vinet(40.9168756740098, 0.5493839427843088, 4.3051929493806345, -10.846160810983498)

dualplot(bm; label="Birch–Murnaghan")
dualplot!(m; label="Murnaghan")
dualplot!(pt; label="Poirier–Tarantola")
dualplot!(v; label="Vinet")
savefig("plot.svg"); nothing # hide
```

![](plot.svg)
