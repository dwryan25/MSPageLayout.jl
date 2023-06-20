using HmtArchive
using HmtArchive.Analysis
using CitablePhysicalText
using CitableObject
using CitableText
using CitableImage
using CitableBase
using JuMP
using HiGHS

using Documenter
using DocStringExtensions

include("TextDataHelper.jl")
include("ZoneHelper.jl")


model = Model(HiGHS.Optimizer)

va = hmt_codices()[6]
dse = hmt_dse()[1]
# Pre-processing to get the necessary pair and zone data
pg = va.pages[70].urn
pairlist = MSPageLayout.findPairs(pg, dse)
zones = MSPageLayout.getZones(pg)
centroidlist = MSPageLayout.getAllCentroidPairs(pairlist,dse)
n = length(centroidlist)
pairsdimensions = pairsDimensions(pairlist, dse)
m = length(pairsdimensions)
#All vectors in bounds <-> are parallel
#e.g. x[1] and sx[1] are matching iliad text and scholia values
#<--------------------------------------
#iliad text dimensions
x = pairsdimensions[1][1:m]
y = pairsdimensions[2][1:m]
w = pairsdimensions[3][1:m]
h = pairsdimensions[4][1:m]
#scholia text dimensions
sx = pairsdimensions[5][1:m]
sy = pairsdimensions[6][1:m]
sw = pairsdimensions[7][1:m]
sh = pairsdimensions[8][1:m]
#centroids
x1 = centroidlist[1:n][1]
x2 = centroidlist[1:n][3]
y1 = centroidlist[1:n][2]
y2 = centroidlist[1:n][4]
#---------------------------------------->
@variable(model, begin
    #centroid data
    x1 >= 0
    x2 >= 0
    y1 >= 0
    y2 >= 0
    #dimensional data for iliad text
    x >= 0
    y >= 0
    w >= 0
    h >= 0
    #dimensional data for scholia text
    sx >= 0
    sy >= 0
    sw >= 0
    sh >= 0
end)
#TODO
@constraints()

@objective(model, min, sqrt(abs(x2-x1)^2 + abs(y2-y1)^2))


