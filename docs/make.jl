using Documenter, CoordinateReferenceSystems

makedocs(;
    modules=[CoordinateReferenceSystems],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/rafaqz/CoordinateReferenceSystems.jl/blob/{commit}{path}#L{line}",
    sitename="CoordinateReferenceSystems.jl",
    authors="Rafael Schouten <rafaelschouten@gmail.com>",
    assets=String[],
)

deploydocs(;
    repo="github.com/rafaqz/CoordinateReferenceSystems.jl",
)
