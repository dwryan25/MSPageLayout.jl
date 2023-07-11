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
function traditional_score(pgdata::PageData; threshold = 0.1, siglum = "msA")::PageScore
    #set successes and failures to zero
    successes = 0
    failures = 0
    if isnothing(siglum)
        new_ys = model_traditional_layout(pgdata)
        orig = scholion_y_tops(pgdata)
    else
        new_ys = model_traditional_layout(pgdata, siglum = "msA")
        orig = mainscholion_y_tops(pgdata)
    end
    for i in eachindex(new_ys)
        topmargin = orig[i] + threshold
        bottommargin = orig[i] - threshold
        if bottommargin <= new_ys[i] <= topmargin
            successes += 1
        else
            failures += 1
        end
    end
    return PageScore(pgdata.pageurn, successes, failures)
end

"""Score number of scholia correctly placed on page using Churik's model.
Optionally specific siglum of scholia to model. If `siglum` is `nothing`, include all scholia.
$(SIGNATURES)
"""
function churik_score(pgdata::PageData; threshhold = 0.1, siglum = "msA")::PageScore
   
    nothing
end