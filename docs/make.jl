using Documenter
using EquationOfStateRecipes
using EquationsOfStateOfSolids
using Plots
using Unitful
using UnitfulAtomic

# See https://stackoverflow.com/questions/70137119/how-to-include-the-docstring-for-a-function-from-another-package-in-my-julia-doc
DocMeta.setdocmeta!(EquationsOfStateOfSolids, :DocTestSetup, :(using EquationsOfStateOfSolids); recursive=true)
DocMeta.setdocmeta!(EquationOfStateRecipes, :DocTestSetup, :(using EquationOfStateRecipes); recursive=true)
DocMeta.setdocmeta!(Plots, :DocTestSetup, :(using Plots); recursive=true)
DocMeta.setdocmeta!(Unitful, :DocTestSetup, :(using Unitful); recursive=true)
DocMeta.setdocmeta!(UnitfulAtomic, :DocTestSetup, :(using UnitfulAtomic); recursive=true)

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
        "Manual" => [
            "Installation Guide" => "man/installation.md",
            "Examples" => "man/examples.md",
            "Troubleshooting" => "man/troubleshooting.md",
        ],
        "Reference" => Any[
            "Public API" => "lib/public.md",
            # "Internals" => map(
            #     s -> "lib/internals/$(s)",
            #     sort(readdir(joinpath(@__DIR__, "src/lib/internals")))
            # ),
        ],
        "Developer Docs" => [
            "Contributing" => "developers/contributing.md",
            "Style Guide" => "developers/style-guide.md",
            "Design Principles" => "developers/design-principles.md",
        ],
    ],
)

deploydocs(;
    repo="github.com/MineralsCloud/EquationOfStateRecipes.jl",
    devbranch="main",
)
