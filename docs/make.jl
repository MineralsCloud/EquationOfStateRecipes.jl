using EquationOfStateRecipes
using Documenter

makedocs(;
    modules=[EquationOfStateRecipes],
    authors="Qi Zhang <singularitti@outlook.com>",
    repo="https://github.com/MineralsCloud/EquationOfStateRecipes.jl/blob/{commit}{path}#L{line}",
    sitename="EquationOfStateRecipes.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://MineralsCloud.github.io/EquationOfStateRecipes.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/MineralsCloud/EquationOfStateRecipes.jl",
)
