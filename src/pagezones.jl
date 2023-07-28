#Write functions to separately retrieve the width of each zone (top, exterior, and middle)

"""Computes the width of the proposed exterior zone on a page differentiating between verso and recto pages.
$(SIGNATURES)
"""
function exteriorzone_width(pgdata::PageData; digits = 3)
    scale = pagescale_x(pgdata, digits = digits)
    offset = pageoffset_left(pgdata, digits = digits)
    if endswith(pgdata.pageurn.urn, "r")
        w = 1 - iliad_x_right(pgdata.textpairs[1], scale = scale, offset = offset, digits = digits)
    elseif endswith(pgdata.pageurn.urn, "v")
       w = iliad_x_left(pgdata.textpairs[1], scale = scale, offset = offset, digits = digits)
    end
    return w
end

"""Compute the bottom y value of the exterior zone
$(SIGNATURES)
"""
function exteriorzone_y_bottom(pgdata::PageData; digits = 3)
    scale = pagescale_y(pgdata, digits = digits)
    offset = pageoffset_top(pgdata, digits = digits)

    round((pgdata.zonepois[2] - offset) * scale, digits = digits)
end

"""Compute the top y value of the exterior zone
$(SIGNATURES)
"""
function exteriorzone_y_top(pgdata::PageData; digits = 3)
    scale = pagescale_y(pgdata, digits = digits)
    offset = pageoffset_top(pgdata, digits = digits)
    
    round((pgdata.zonepois[1] - offset) * scale, digits = digits)
end