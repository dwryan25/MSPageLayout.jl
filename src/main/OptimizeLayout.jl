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

pg = va.pages[70].urn
pairlist = MSPageLayout.findPairs(pg, dse)
zones = MSPageLayout.getZones(pg)
centroidlist = MSPageLayout.getAllCentroidPairs(pairlist,dse)
n = length(centroidlist)
x1 = centroidlist[1:n][1]
x2 = centroidlist[1:n][3]
y1 = centroidlist[1:n][2]
y2 = centroidlist[1:n][4]

@variable(model, begin
    #centroid data
    x1 >= 0
    x2 >= 0
    y1 >= 0
    y2 >= 0
    #dimensional data
    x >= 0
    y >= 0
    w >= 0
    h >= 0
    
end)

@objective(model, min, sqrt(abs(x2-x1)^2 + abs(y2-y1)^2))


