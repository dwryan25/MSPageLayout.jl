
""" Returns a vector of all the main scholia on a page and their
matching lines. 
"""
function findPairs(pg::Cite2Urn, dse::DSECollection)
    idx = hmt_commentary()[1]
    text = textsforsurface(pg, dse)
    pairs = Vector{Tuple{CtsUrn, CtsUrn}}[]
    scholias = filter(txt->startswith(workcomponent(txt), "tlg5026.msA.hmt"), text)
        for scholia in scholias
            matches = filter(pr->pr[1] == scholia, idx.commentary)
            push!(pairs, matches)
        end
    return pairs
end

function getSchCentroid(schUrn:: CtsUrn, dse::DSECollection)
    imgUrn = imagesfortext(schUrn, dse)
    imgData = split(subref(imgUrn[1]), ",")
    imgData = map(x->parse(Float16, x), imgData)

    centroidx = imgData[1] + (imgData[3]/2)
    centroidy = imgData[2] + (imgData[4]/2)

    return [centroidx, centroidy]
end

function getTextCentroid(urn::CtsUrn, dse::DSECollection)
    imgUrn = imagesfortext(urn, dse)
    imgData = split(subref(imgUrn[1]), ",")
    imgData = map(x->parse(Float16, x), imgData)

    centroidx = imgData[1] + (imgData[3]/2)
    centroidy = imgData[2] + (imgData[4]/2)

    return [centroidx, centroidy]
end

function getCentroidPair(pair::Vector{Tuple{CtsUrn, CtsUrn}}, dse::DSECollection)
    texturn = pair[1][2]
    scholiaurn = pair[1][1]

    if occursin("-", texturn.urn)
        touse = split(texturn.urn, "-")[1]
        texturn = CtsUrn(touse)
    end
    tCentroid = getTextCentroid(texturn, dse)
    sCentroid = getSchCentroid(scholiaurn, dse)
    #when calculating x1,x2,y1,y2: x1,y1 is always text box and x2,y2 is scholia
    return [tCentroid[1], sCentroid[1], tCentroid[2], sCentroid[2]]
en
d

function centroidDistance(centroidPair::Vector{Vector{Float16}})
    x1 = centroidPair[1][1]
    x2 = centroidPair[2][1]
    y1 = centroidPair[1][2]
    y2 = centroidPair[2][2]

    xd = abs(x2 - x1)
    yd = abs(y2 - y1)
    xandy = xd^2 + yd^2
    dist = sqrt(xandy)
    return dist
end

function getSchArea(xywh:: Vector{Float16})
    area = xywh[3] * xywh[4] 
    return area
end 

function getAllCentroidPairs(pairlist::Vector{Vector{Tuple{CtsUrn, CtsUrn}}}, dse::DSECollection)
    centroids = Vector{Float16}[]
    for pair in pairlist 
        push!(centroids, getCentroidPair(pair, dse))
    end

    return centroids
end

function getPairDimensions(pair::Vector{Tuple{CtsUrn, CtsUrn}}, dse::DSECollection)
    texturn = pair[1][2]
    scholiaurn = pair[1][1]

    if occursin("-", texturn.urn)
        touse = split(texturn.urn, "-")[1]
        texturn = CtsUrn(touse)
    end
    imgUrn = imagesfortext(texturn, dse)
    imgData = split(subref(imgUrn[1]), ",")
    imgData = map(x->parse(Float16, x), imgData)

    schimg = imagesfortext(scholiaurn, dse)

end

function pairsDimensions(pairlist::Vector{Vector{Tuple{CtsUrn, CtsUrn}}}, dse::DSECollection)
    for pair in pairlist
        push!(dimensions, getPairDimensions(pair, dse))
    end
end