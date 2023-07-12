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


include("utils.jl")
include("boxedtext.jl")
include("pagedata.jl")
include("layout_analysis.jl")
include("score_results.jl")


export PageData, pageData
# functions page PageData:
export scholion_y_tops, scholion_y_centers, scholion_heights, mainscholion_y_tops
export iliad_y_tops
export pageoffset_top, pageoffset_left
export pagescale_y, pagescale_x

export BoxedTextPair
# functions on BoxedTextPairs:
export scholion_x_left, scholion_x_right, scholion_x_center
export scholion_y_top, scholion_y_bottom, scholion_y_center

export iliad_x_left, iliad_x_right, iliad_x_center
export iliad_y_top, iliad_y_bottom, iliad_y_center

export scholion_height
export exteriorzone_width

export model_traditional_layout

export traditional_score

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
