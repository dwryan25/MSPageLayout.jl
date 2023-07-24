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
include("pagezones.jl")


export PageData, pageData
# functions on page PageData:
export scholion_y_tops, scholion_y_centers, scholion_heights, mainscholion_y_tops, scholion_widths, scholion_areas
export iliad_y_tops, iliad_x_centers
export pageoffset_top, pageoffset_left
export pagescale_y, pagescale_x

export BoxedTextPair
# functions on BoxedTextPairs:
export scholion_x_left, scholion_x_right, scholion_x_center
export scholion_y_top, scholion_y_bottom, scholion_y_center

export iliad_x_left, iliad_x_right, iliad_x_center
export iliad_y_top, iliad_y_bottom, iliad_y_center

export scholion_height, scholion_width, scholion_area

#functions on pagezones
export exteriorzone_width, exteriorzone_y_bottom, exteriorzone_y_top

#functions on layout_analysis
export model_traditional_layout


export PageScore
#functions on scoring
export traditional_score_page
export traditional_score_manuscript
export delimited, resultsfromdelimited

end # module MSPageLayout
