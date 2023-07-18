"""A scholion paired with the *Iliad* line it comments on.
Each text passage has a corresponding image with region of interest.
"""
struct BoxedTextPair
    scholion::CtsUrn
    scholionbox::Cite2Urn
    iliadline::CtsUrn
    iliadbox::Cite2Urn
    lineindex::Union{Int, Nothing}
end

"""Compute height of scholion text box.
$(SIGNATURES)
"""
function scholion_height(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)::Union{Float64, Nothing}
    b = scholion_y_bottom(textpair, digits = digits, scale = scale, offset = offset)
    t = scholion_y_top(textpair, digits = digits, scale = scale, offset = offset)
    if isnothing(b) || isnothing(t)
        nothing
    else 
        round(b - t, digits = digits)
    end
end
"""Compute width of scholion text box
$(SIGNATURES)
"""
function scholion_width(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)::Union{Float64, Nothing}
    l = scholion_x_left(textpair, digits = digits, scale = scale, offset = offset)
    r = scholion_x_right(textpair, digits = digits, scale = scale, offset = offset)
    if isnothing(l) || isnothing(r)
        nothing
    else 
        round(r - l, digits = digits)
    end
end

"""Compute left edge of `scholionbox`.
$(SIGNATURES)
"""
function scholion_x_left(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)::Union{Float64, Nothing}
    floats = imagefloats(textpair.scholionbox, digits = digits)
    if isnothing(floats)
        nothing
    else
        round((floats[1] - offset) * scale, digits = digits)
    end
end

"""Compute right edge of `scholionbox` within page zone.
$(SIGNATURES)
"""
function scholion_x_right(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)::Union{Float64, Nothing}
    floats = imagefloats(textpair.scholionbox, digits = digits)
    if isnothing(floats)
        nothing
    else 
        round(((floats[1]-offset) * scale) + (floats[3]*scale), digits = digits)
    end
end


"""Compute center in x  of `scholionbox` within page zone.
$(SIGNATURES)
"""
function scholion_x_center(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)::Union{Float64, Nothing}
    r = scholion_x_right(textpair, digits = digits, scale = scale, offset = offset)
    l = scholion_x_left(textpair, digits = digits, scale = scale, offset = offset)
    if isnothing(l) || isnothing(r)
        nothing
    else 
        round((r - l) / 2, digits = digits)
    end
end

"""Compute top edge of `scholionbox`.
$(SIGNATURES)
"""
function scholion_y_top(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)::Union{Float64, Nothing}
    floats = imagefloats(textpair.scholionbox, digits = digits)
    if isnothing(floats)
        nothing
    else   
        round((floats[2] - offset) * scale, digits = digits)
    end
end

"""Compute bottom edge of `scholionbox` within page zone.
$(SIGNATURES)
"""
function scholion_y_bottom(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)::Union{Float64, Nothing}
    floats = imagefloats(textpair.scholionbox, digits = digits)
    if isnothing(floats)
        nothing
    else 
        round(((floats[2]-offset) * scale) + (floats[4]*scale), digits = digits)
    end
end


"""Compute center in y  of `scholionbox` within page zone.
$(SIGNATURES)
"""
function scholion_y_center(textpair::BoxedTextPair;digits = 3, scale = 1.0, offset = 0)::Union{Float64, Nothing}
    b = scholion_y_bottom(textpair, digits = digits, scale = scale, offset = offset)
    t = scholion_y_top(textpair, digits = digits, scale = scale, offset = offset)
    if isnothing(b) || isnothing(t)
        nothing
    else 
        round((t + b) / 2, digits = digits)
    end
end

"""Compute left edge of `iliadbox`.
$(SIGNATURES)
"""
function iliad_x_left(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)::Union{Float64, Nothing}
    floats = imagefloats(textpair.iliadbox, digits = digits)
    if isnothing(floats)
        nothing
    else
        round((floats[1] - offset) * scale, digits = digits)
    end
end

"""Compute right edge of `iliadbox` within page zone.
$(SIGNATURES)
"""
function iliad_x_right(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)::Union{Float64, Nothing}
    floats = imagefloats(textpair.iliadbox, digits = digits)
    if isnothing(floats)
        nothing
    else
        round(((floats[1]-offset) * scale) + (floats[3]*scale), digits = digits)
    end
end


"""Compute center in x  of `iliadbox` within page zone.
$(SIGNATURES)
"""
function iliad_x_center(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)::Union{Float64, Nothing}
    r = iliad_x_right(textpair, digits = digits, scale = scale, offset = offset)
    l = iliad_x_left(textpair, digits = digits, scale = scale, offset = offset)
    if isnothing(l) || isnothing(r)
        nothing
    else 
        round((r + l) / 2, digits = digits)
    end
end

"""Compute top edge of `iliadbox`.
$(SIGNATURES)
"""
function iliad_y_top(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)::Union{Float64, Nothing}
    floats = imagefloats(textpair.iliadbox, digits = digits)
    if isnothing(floats)
        nothing
    else 
        round((floats[2] - offset) * scale, digits = digits)
    end
end

"""Compute bottom edge of `iliadbox` within page zone.
$(SIGNATURES)
"""
function iliad_y_bottom(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)::Union{Float64, Nothing}
    floats = imagefloats(textpair.iliadbox, digits = digits)
    if isnothing(floats)
        nothing
    else
        round(((floats[2] - offset) * scale) + (floats[4] * scale), digits = digits)
    end 
end

"""Compute center in y  of `iliadbox` within page zone.
$(SIGNATURES)
"""
function iliad_y_center(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)::Union{Float64, Nothing}
    b = iliad_y_bottom(textpair, digits = digits, scale = scale, offset = offset)
    t = iliad_y_top(textpair, digits = digits, scale = scale, offset = offset)
    if isnothing(b) || isnothing(t)
        nothing
    else 
        round((t + b) / 2, digits = digits)
    end
end
"""
Compute area of scholion.
$(SIGNATURES)
"""
function scholion_area(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)::Union{Float64, Nothing}
    length = scholion_height(textpair, digits = digits, scale = scale, offset = offset)
    width = scholion_width(textpair, digits = digits, scale = scale, offset = offset)
    if isnothing(length) || isnothing(width)
        nothing
    else 
        round(length*width, digits = digits)
    end
end
