
""" Returns a vector of TSPairs. A TSPair has two subtypes: an iliad text urn and a scholia text urn 
"""
function findPairs(pg::Cite2Urn; dse = dse)
    dse = if isnothing(dse)
        hmt_dse()[1]
    else 
        dse
    end
    idx = hmt_commentary()[1]
    text = textsforsurface(pg, dse)
    pairlist = TSPair[]
    scholias = filter(txt->startswith(workcomponent(txt), "tlg5026.msA.hmt"), text)
        for scholia in scholias
            matches = filter(pr->pr[1] == scholia, idx.commentary)
            curpair = TSPair(matches[1][2], matches[1][1])
            push!(pairlist, curpair)
        end
    return pairlist
end
"""Parses a scholia text urn's image data and calculates the centroid of the image
"""
function getSchCentroid(schUrn::CtsUrn, dse::DSECollection)
    imgUrn = imagesfortext(schUrn, dse)
    imgData = split(subref(imgUrn[1]), ",")
    imgData = map(x->parse(Float16, x), imgData)

    centroidx = imgData[1] + (imgData[3]/2)
    centroidy = imgData[2] + (imgData[4]/2)

    return [centroidx, centroidy]
end
"""Parses an iliad text urn's image data and calculates the centroid of the image.
"""
function getTextCentroid(urn::CtsUrn, dse::DSECollection)
    imgUrn = imagesfortext(urn, dse)
    imgData = split(subref(imgUrn[1]), ",")
    imgData = map(x->parse(Float16, x), imgData)

    centroidx = imgData[1] + (imgData[3]/2)
    centroidy = imgData[2] + (imgData[4]/2)

    return [centroidx, centroidy]
end
"""Parses a single pair to retrieve the centroid value of each pair.
Returns data in the format [x1, x2, y1, y2]. x1 and y1 being the iliad text box, x2 and y2 
being the scholia text box.
"""
function getCentroidPair(pair::TSPair, dse::DSECollection)
    texturn = pair.iliadtext
    scholiaurn = pair.scholiatext

    if occursin("-", texturn.urn)
        touse = split(texturn.urn, "-")[1]
        texturn = CtsUrn(touse)
    end
    tCentroid = getTextCentroid(texturn, dse)
    sCentroid = getSchCentroid(scholiaurn, dse)
    #when calculating x1,x2,y1,y2: x1,y1 is always iliad text box and x2,y2 is scholia text box
    return [tCentroid[1], sCentroid[1], tCentroid[2], sCentroid[2]]
end
"""Gets the distance between centroids
"""
function centroidDistance(centroidPair::Vector{Vector{Float16}})
    x1 = centroidPair[1][1]
    x2 = centroidPair[2][1]
    y1 = centroidPair[1][2]
    y2 = centroidPair[2][2]

    xd = x2 - x1
    yd = y2 - y1
    xandy = xd^2 + yd^2
    dist = sqrt(xandy)
    return dist
end

function getSchArea(xywh:: Vector{Float16})
    area = xywh[3] * xywh[4] 
    return area
end 
"""Returns a vector of a vector of floats containing the centroids of each iliad text box
and its corresponding scholia. 
"""
function getAllCentroidPairs(pairlist::Vector{TSPair}, dse::DSECollection)
    centroids = Vector{Float16}[]
    for pair in pairlist 
        push!(centroids, getCentroidPair(pair, dse))
    end

    return centroids
end
"""Returns a vector of two four-element vectors. Each vector of 4 contains the coordinates 
of a text box. the first element of the return value is iliad text data and the second is
scholia data. 
"""
function getPairDimensions(pair::TSPair, dse::DSECollection)
    texturn = pair.iliadtext
    scholiaurn = pair.scholiatext

    if occursin("-", texturn.urn)
        touse = split(texturn.urn, "-")[1]
        texturn = CtsUrn(touse)
    end
    textimgUrn = imagesfortext(texturn, dse)
    textimgData = split(subref(textimgUrn[1]), ",")
    textimgData = map(x->parse(Float16, x), textimgData)

    schimgUrn = imagesfortext(scholiaurn, dse)
    schimgData = split(subref(schimgUrn[1]), ",")
    schimgData = map(x->parse(Float16, x), schimgData)
    #order is always text and then scholia
    return [textimgData, schimgData]
end

"""Streamlines the dimensional data of each text box into 4 vectors for main text and 
4 vectors for scholia text such that the dimensions of the ith box are specified by x[i],
y[i], w[i], h[i]. Returns a vector of vectors containing the dimensional data. 
Reference table for parsing data from return value of type Vector{Vector{Float16}}:
indices | value
1         iliad text x vals
2         iliad text y vals
3         iliad text w vals
4         iliad text h vals
5         scholia text x vals
6         scholia text y vals
7         scholia text w vals
8         scholia text h vals
"""
function pairsDimensions(pairlist::Vector{TSPair}, dse::DSECollection)
    dimensions = Vector{Vector{Float16}}[]
    for pair in pairlist
        push!(dimensions, getPairDimensions(pair, dse))
    end
    textxvals = Float16[]
    textyvals = Float16[]
    textwvals = Float16[]
    texthvals = Float16[]
    
    scholiaxvals = Float16[]
    scholiayvals = Float16[]
    scholiawvals = Float16[]
    scholiahvals = Float16[]
    for p in eachindex(dimensions)
        push!(textxvals, dimensions[p][1][1])
        push!(textyvals, dimensions[p][1][2])
        push!(textwvals, dimensions[p][1][3])
        push!(texthvals, dimensions[p][1][4])

        push!(scholiaxvals, dimensions[p][2][1])
        push!(scholiayvals, dimensions[p][2][2])
        push!(scholiawvals, dimensions[p][2][3])
        push!(scholiahvals, dimensions[p][2][4])
    end
    return [textxvals, textyvals, textwvals, texthvals, scholiaxvals, scholiayvals, scholiawvals, scholiahvals]
end