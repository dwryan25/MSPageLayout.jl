#Write functions to separately retrieve the width of each zone (top, exterior, and middle)

"""Computes the width of the proposed exterior zone on a page differentiating between verso and recto pages.
"""
function exteriorzone_width(pgdata::PageData; digits = 3)
    w::Int64
    scale = pagescale_x(pgdata, digits = digits)
    offset = pageoffset_x(pgdata, digits = digits)
    if endswith(pgdata.pageurn, "r")
        1 - iliad_x_right(pgdata.textpairs[1], scale = scale, offset = offset, digits = digits)
    elseif endswith(pgdata.pageurn, "v")
       w = iliad_x_left(pgdata.textpairs[1], scale = scale, offset = offset, digits = digits)
    end
    
end
