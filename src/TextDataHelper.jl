
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


function getSchArea(xywh:: Vector{Float16})
    area = xywh[3] * xywh[4] 
    return area
end 