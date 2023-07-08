module MSPageLayout

using JuMP
using HiGHS

using HmtArchive
using HmtArchive.Analysis
using CitablePhysicalText
using CitableObject
using CitableText
using CitableImage
using CitableBase

using Documenter
using DocStringExtensions

include("boxedtext.jl")
include("pagedata.jl")
include("layout_analysis.jl")
include("score_results.jl")


export PageData, pageData
export BoxedTextPair


#=
export PageSkeleton
export TSPair
export PageLayout
include("PageSkeleton.jl")
include("TSPair.jl")
include("PageLayout.jl")
include("ZoneHelper.jl")
include("TextDataHelper.jl")
include("FinalPageData.jl")
include("PageOptimizer.jl")
=#

end # module MSPageLayout
