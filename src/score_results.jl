"""Record of score for analysis of a page.
$(SIGNATURES)
"""
struct PageScore
    pgurn::Cite2Urn
    successes::Int
    failures::Int
end

"""Score number of scholia correctly placed on page using traditional model. Optionally specific siglum of scholia to model. If `siglum` is `nothing`, include all scholia.

$(SIGNATURES)
"""
function traditional_score(pgdata::PageData; threshhold = 0.1, siglum = "msA")::PageScore
   
    nothing
end

"""Score number of scholia correctly placed on page using Churik's model.
Optionally specific siglum of scholia to model. If `siglum` is `nothing`, include all scholia.
$(SIGNATURES)
"""
function churik_score(pgdata::PageData; threshhold = 0.1, siglum = "msA")::PageScore
   
    nothing
end