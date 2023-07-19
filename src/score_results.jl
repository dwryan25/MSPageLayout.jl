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
function traditional_score_page(pgdata::PageData; threshold = 0.1, siglum = "msA")::PageScore
    #set successes and failures to zero
    successes = 0
    failures = 0
    
    new_ys = model_traditional_layout(pgdata, siglum = siglum)
    orig = mainscholion_y_tops(pgdata)
    if new_ys !== nothing
        for i in eachindex(new_ys)
            if isnothing(orig[i]) || isnothing(new_ys[i])
                failures += 1
                continue
            end
            topmargin = orig[i] + threshold
            bottommargin = orig[i] - threshold
            if bottommargin <= new_ys[i] <= topmargin
                successes += 1
            else
                failures += 1
            end
        end
        return PageScore(pgdata.pageurn, successes, failures)
    else 
        return PageScore(pgdata.pageurn, 0, 0)
    end
end

"""Score an entire manuscript, optimizing the y value layout for each page
and comparing to the original. Returns a vector of PageScores.
$(SIGNATURES)
"""
function traditional_score_manuscript(manuscript::Codex)
    mspages = manuscript.pages
    scores = PageScore[]
    for page in mspages
        pgdata = pageData(page.urn)
        if pgdata === nothing
            continue
        else
            score = traditional_score_page(pgdata, threshold = 0.05)
            push!(scores, score)
        end
    end
    return scores
end
"""Creates a vector of PageScores by reading data from a score file.
$(SIGNATURES)
"""
function get_score_vector(filename::String)
    scores = PageScore[]
    open(filename) do file
        for line in eachline(file)
            if startswith(line, "Header:" )
                continue
            else
                push!(scores, line)
            end        
        end
    end
    return scores
end
"""Computes the ratio of successful pages to all pages. Benchmark parameter specifies how many successes a PageScore
needs to consider the page a success.
"""
function successes_ratio(scores::Vector{PageScore}, benchmark::Float64)
    successful_pages::Int64
    total_pages = length(scores)
    for score in scores
        s = score.successes
        f = score.failures
        if s / (s + f) >= benchmark
            successful_pages += 1
        end
    end
    return successful_pages / total_pages
end
"""Score number of scholia correctly placed on page using Churik's model.
Optionally specific siglum of scholia to model. If `siglum` is `nothing`, include all scholia.
$(SIGNATURES)
"""
function churik_score(pgdata::PageData; threshhold = 0.1, siglum = "msA")::PageScore
   
    nothing
end