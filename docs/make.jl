using EquationOfStateRecipes
using Documenter

DocMeta.setdocmeta!(EquationOfStateRecipes, :DocTestSetup, :(using EquationOfStateRecipes); recursive=true)

makedocs(;
    modules=[EquationOfStateRecipes],
    authors="Qi Zhang <singularitti@outlook.com>",
    repo="https://github.com/MineralsCloud/EquationOfStateRecipes.jl/blob/{commit}{path}#{line}",
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
