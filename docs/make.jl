# Build docs from root directory of repository:
#
#     julia --project=docs/ docs/make.jl
#
# Serve docs from repository root:
#
#   julia -e 'using LiveServer; serve(dir="docs/build")'julia -e 'using LiveServer; serve(dir="docs/build")' 
#
using Pkg
Pkg.activate(".")
Pkg.instantiate()


using Documenter, DocStringExtensions, MSPageLayout

makedocs(
    sitename = "CitableCorpus.jl",
    pages = [
        "Overview" => "index.md",
  
        "API documentation" => "api.md"
        ]
    )


deploydocs(
    repo = "github.com/dwryan25/MSPageLayout.jl.git",
) 