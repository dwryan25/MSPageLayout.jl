ASSUMED_LINES = 24


"""Rank the relative sequence of an *Iliad* line `i`
in one of the three page zones.
$(SIGNATURES)
"""
function iliadzone(i::Int; span = 6, linesonpage = ASSUMED_LINES)
    if i <= span
        :top
    elseif i >= (linesonpage  - span)
        :bottom
    else
        :middle
    end
end

"""Place the actual placement of a scholion on the page in
in one of the three page zones.
$(SIGNATURES)
"""
function scholionzone(scholion_y, topthresh, bottomthresh)
    if scholion_y <= topthresh
        :top
    elseif scholion_y >= bottomthresh
        :bottom
    else 
        :middle
    end
end

"""True if zone placement matches for scholion and *Iliad* line.
$(SIGNATURES)
"""
function churik_model_matches(pr::BoxedTextPair, scalefactor, offset, topcutoff, bottomcutoff)
    iliadregion = iliadzone(pr.lineindex)

    ytop = scholion_y_top(pr, scale = scalefactor, offset = offset)
    scholionregion = scholionzone(ytop, topcutoff, bottomcutoff)
    scholionregion == iliadregion
end

