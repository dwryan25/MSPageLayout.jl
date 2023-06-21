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
pairlist = MSPageLayout.findPairs(pg, dse = dse)
zones = MSPageLayout.getZones(pg)
centroidlist = MSPageLayout.getAllCentroidPairs(pairlist,dse)
n = length(centroidlist)
pairsdimensions = pairsDimensions(pairlist, dse)
m = length(pairsdimensions)
#Zone data pre-processing
topzone = zone[1]
extzone = zone[2]
bottomzone = zone[3]

tx = topzone[1]
ty = topzone[2]
tw = topzone[3]
th = topzone[4]

ex = extzone[1]
ey = extzone[2]
ew = extzone[3]
eh = extzone[4]

bx = bottomzone[1]
by = bottomzone[2]
bw = bottomzone[3]
bh = bottomzone[4]
#All vectors in bounds <-> are parallel
#e.g. x[4] and sx[4] are matching iliad text and scholia values for the
#4th scholia on the page
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
    #zone data
    tx >= 0
    ty >= 0
    tw >= 0
    th >= 0
    ex >= 0
    ey >= 0
    ew >= 0
    eh >= 0
    bx >= 0
    by >= 0
    bw >= 0
    bh >= 0
end)
i = [1:n]
j = [1:m]
@constraints(begin
    #scholia must go in numbered order from top down
    sy[i] + sh[i] <= sy[i+1]
    #must fit within zones; here is defined where the scholia cannot go
    sx >= tx #scholia must be within entire text box from lef
    sx <= ex +ew #scholia must be within entire text box from right
    sy >= ty #scholia must be within entire text box from top to bottom
    sy <= th + eh + bh # scholia must be within entire text box from bottom to top
    sy + sh <= ty + th #scholia must be outside of Iliad text box
    sy + sh >= ty + th + eh #scholia must be outside of iliad text box
    
end)

@objective(model, min, sqrt(abs(x2-x1)^2 + abs(y2-y1)^2))


