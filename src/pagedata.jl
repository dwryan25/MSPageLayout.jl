"""HMT project data for a page.
"""
struct PageData
    pageurn::Cite2Urn
    textpassages::Vector{CtsUrn}
    commentarypairs
    imagezone::Cite2Urn
end


"""Construct a `PageData` object for the
page identified by `pageurn`.  Optionally include
a full HMT project dataset in the `data` parameter.
Return `nothing` if no page region is available for an image.
"""
function pageData(pageurn::Cite2Urn; data = nothing)::Union{PageData, Nothing}
    hmtdata = isnothing(data) ? hmt_cex() : data
    dse = hmt_dse(hmtdata)[1]
    textpassages = textsforsurface(pageurn, dse)
    
    scholia = filter(psg -> startswith(workcomponent(psg), "tlg5026"), textpassages)
    allcommentary = hmt_commentary(hmtdata)[1]
    commpairs = filter(pr -> pr[1] in scholia, allcommentary.commentary)

    allpagerois = hmt_pagerois(hmtdata)
    matchingrois = filter(pr -> pr[1] == pageurn, allpagerois.index)
    if length(matchingrois) == 1
        PageData(pageurn,
        textpassages,
        commpairs,
        matchingrois[1][2]
        )
    elseif isempty(matchingrois)
        @warn("No page region found.")
        nothing
    else
        @warn("Multiple page regions found.")
        nothing
    end
end