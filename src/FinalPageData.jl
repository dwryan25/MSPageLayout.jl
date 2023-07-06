"""Adjusts the coordinates of page from the codex browser to scale to the region of interest. 
    returns a PageLayout object with all the necessary data to begin optimization
"""
function adjustCoords(pg::Cite2Urn, dse::DSECollection)
    pairlist = MSPageLayout.findPairs(pg, dse = dse)
    zones = MSPageLayout.getZones(pg, dse = dse)
    centroidlist = MSPageLayout.getAllCentroidPairs(pairlist, dse)
    pdimensions = MSPageLayout.pairsDimensions(pairlist, dse)
    correction = MSPageLayout.getCorrection(pg)

    #map correction to zones
    #x and y vals minus correction
    for i = 1:4
       zones[i][1] = map(x->x-correction[1], zones[i][1])
       zones[i][2] = map(y->y-correction[2], zones[i][2])
    end
    #w and h vals plus correction
    for i = 1:4
        zones[i][3] = map(w->w+correction[3], zones[i][3])
        zones[i][4] = map(h->h+correction[4], zones[i][4])
    end
    zones = PageSkeleton(zones[1], zones[2], zones[3], zones[4])
    #map correction to pairs dimensions 
    for i = 1:2
        pdimensions[i] = map(x->x-correction[i], pdimensions[i])
    end
    for i = 3:4
        pdimensions[i] = map(x->x+correction[i-2], pdimensions[i])
    end
    for i = 5:6
        pdimensions[i] = map(x->x-correction[i-4], pdimensions[i])
    end
    for i = 7:8
        pdimensions[i] = map(x->x+correction[i-6], pdimensions[i])
    end
    #map correction to centroids
    for i = 1:length(centroidlist)
        centroidlist[i][1] = map(x->x-correction[1], centroidlist[i][1])
        centroidlist[i][2] = map(y->y-correction[2], centroidlist[i][2])
        centroidlist[i][3] = map(y->y-correction[1], centroidlist[i][3])
        centroidlist[i][4] = map(y->y-correction[2], centroidlist[i][4])
    end
    layout = PageLayout(zones, centroidlist, pdimensions)
    return layout
end
"""Function to get the page layout of a given page and manuscript. 
    Returns a PageLayout object. 
    $(SIGNATURES)
"""
function getPageLayout(pgnum::Int64, manuscript::Codex, dse::DSECollection)
    pg = manuscript.pages[pgnum].urn
    layout = adjustCoords(pg, dse)
    return layout
end
    