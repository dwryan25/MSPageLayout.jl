"""Record of score for analysis of a page.
$(SIGNATURES)
"""
struct PageScore
    pgurn::Cite2Urn
    successes::Int
    failures::Int
end



"""Serialize score for a single page.
$(SIGNATURES)
"""
function delimited(pgScore::PageScore; delimiter = ",")
    string(pgScore.pgurn, delimiter, pgScore.successes, delimiter, pgScore.failures)
end

"""Instantiate a single `PageScore` object freom a delimited-text source.
$(SIGNATURES)
"""
function resultsfromdelimited(txt; delimiter = ",")
    columns = split(txt, delimiter)
    u = Cite2Urn(columns[1])
    successes = parse(Int, columns[2])
    failures = parse(Int, columns[3])
    PageScore(u, successes, failures)
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
    if new_ys === nothing
        return PageScore(pgdata.pageurn, 0, 0)
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

"""Score an entire manuscript, optimizing the y value layout for each page
and comparing to the original. Returns a vector of PageScores.
$(SIGNATURES)
"""
function traditional_score_manuscript(manuscript::Codex, data = nothing)
    data = if isnothing(data)
        hmt_cex()
    else 
        data
    end
    mspages = manuscript.pages
    scores = PageScore[]
    for page in mspages
        pgdata = pageData(page.urn, data = data)
        if pgdata === nothing
            continue
        else
        score = traditional_score_page(pgdata, threshold = 0.05)
        push!(scores, score)
        end
    end

    return scores
end

"""Score number of scholia correctly placed on page using Churik's model.
Optionally specific siglum of scholia to model. If `siglum` is `nothing`, include all scholia.
$(SIGNATURES)
"""
function churik_score(pgdata::PageData; siglum = "msA")::PageScore
    scalefactor = pagescale_y(pgdata)
    offset = pageoffset_top(pgdata)
    topthreshhold = exteriorzone_y_bottom(pgdata)
    bottomthreshhold = exteriorzone_y_bottom(pgdata)
    
    tfscores = map(pgdata.textpairs) do pr
        if workid(pr) == siglum
            churik_model_matches(pr, scalefactor, offset, topthreshhold, bottomthreshhold)
        end
    end
    successes = filter(tf -> tf == true, tfscores)
    failures = filter(tf -> tf == false, tfscores)
    PageScore(pgdata.pageurn, length(successes), length(failures))
end

function churik_score_manuscript(manuscript::Codex, data = nothing)
    data = if isnothing(data)
        hmt_cex()
    else 
        data
    end
    mspages = manuscript.pages
    scores = PageScore[]
    for page in mspages
        pgdata = pageData(page.urn, data = data)
        if pgdata === nothing
            continue
        else
        score = churik_score(pgdata)
        push!(scores, score)
        end
    end

    return scores
end
