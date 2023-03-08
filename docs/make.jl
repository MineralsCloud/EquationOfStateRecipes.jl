using EquationOfStateRecipes
using EquationsOfStateOfSolids
using Documenter
using Plots
using Unitful
using UnitfulAtomic

DocMeta.setdocmeta!(EquationOfStateRecipes, :DocTestSetup, :(using EquationOfStateRecipes); recursive=true)

makedocs(;
    modules=[EquationOfStateRecipes],
    authors="singularitti <singularitti@outlook.com> and contributors",
    repo="https://github.com/MineralsCloud/EquationOfStateRecipes.jl/blob/{commit}{path}#{line}",
    sitename="EquationOfStateRecipes.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://MineralsCloud.github.io/EquationOfStateRecipes.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Manual" => [
            "Installation Guide" => "installation.md",
            "Examples" => "examples.md",
        ],
        "Public API" => "public.md",
        "Developer Docs" => [
            "Contributing" => "developers/contributing.md",
            "Style Guide" => "developers/style-guide.md",
            "Design Principles" => "developers/design-principles.md",
        ],
        "Troubleshooting" => "troubleshooting.md",
    ],
)

deploydocs(;
    repo="github.com/MineralsCloud/EquationOfStateRecipes.jl",
    devbranch="main",
)
