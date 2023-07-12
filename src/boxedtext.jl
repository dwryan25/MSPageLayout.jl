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
function scholion_height(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)
    b = scholion_y_bottom(textpair, digits = digits, scale = scale, offset = offset)
    t = scholion_y_top(textpair, digits = digits, offset = offset)
    round(b - t, digits = digits)
end
"""Compute width of scholion text box
$(SIGNATURES)
"""
function scholion_width(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)
    l = scholion_x_left(textpair, digits = digits, offset = offset)
    r = scholion_x_right(textpair, digits = digits, scale = scale, offset = offset)
    round(r - l, digits = digits)
end

"""Compute left edge of `scholionbox`.
$(SIGNATURES)
"""
function scholion_x_left(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)
    round((imagefloats(textpair.scholionbox, digits = digits)[1] - offset) * scale, digits = digits)
end

"""Compute right edge of `scholionbox` within page zone.
$(SIGNATURES)
"""
function scholion_x_right(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)
    floats = imagefloats(textpair.scholionbox, digits = digits)
    round(((floats[1]-offset) * scale) + (floats[3]*scale), digits = digits)
end


"""Compute center in x  of `scholionbox` within page zone.
$(SIGNATURES)
"""
function scholion_x_center(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)
    r = scholion_x_right(textpair, digits = digits, scale = scale, offset = offset)
    l = scholion_x_left(textpair, digits = digits, offset = offset)
    round((r - l) / 2, digits = digits)
end

"""Compute top edge of `scholionbox`.
$(SIGNATURES)
"""
function scholion_y_top(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)
    round((imagefloats(textpair.scholionbox, digits = digits)[2] - offset) * scale, digits = digits)
end

"""Compute bottom edge of `scholionbox` within page zone.
$(SIGNATURES)
"""
function scholion_y_bottom(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)
    floats = imagefloats(textpair.scholionbox, digits = digits)
    round(((floats[2]-offset) * scale) + (floats[4]*scale), digits = digits)
end


"""Compute center in y  of `scholionbox` within page zone.
$(SIGNATURES)
"""
function scholion_y_center(textpair::BoxedTextPair;digits = 3, scale = 1.0, offset = 0)
    b = scholion_y_bottom(textpair, digits = digits, scale = scale, offset = offset)
    t = scholion_y_top(textpair, digits = digits, offset = offset)
    round((t + b) / 2, digits = digits)
end

"""Compute left edge of `iliadbox`.
$(SIGNATURES)
"""
function iliad_x_left(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)
    round((imagefloats(textpair.iliadbox, digits = digits)[1] - offset) * scale, digits = digits)
end

"""Compute right edge of `iliadbox` within page zone.
$(SIGNATURES)
"""
function iliad_x_right(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)
    floats = imagefloats(textpair.iliadbox, digits = digits)
    round(((floats[1]-offset) * scale) + (floats[3]*scale), digits = digits)
end


"""Compute center in x  of `iliadbox` within page zone.
$(SIGNATURES)
"""
function iliad_x_center(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)
    r = iliad_x_right(textpair, digits = digits, scale = scale, offset = offset)
    l = iliad_x_left(textpair, digits = digits, offset = offset)
    round((r + l) / 2, digits = digits)
end

"""Compute top edge of `iliadbox`.
$(SIGNATURES)
"""
function iliad_y_top(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)
    round((imagefloats(textpair.iliadbox, digits = digits)[2] - offset) * scale, digits = digits)
end

"""Compute bottom edge of `iliadbox` within page zone.
$(SIGNATURES)
"""
function iliad_y_bottom(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)
    floats = imagefloats(textpair.iliadbox, digits = digits)
    round(((floats[2] - offset) * scale) + (floats[4] * scale), digits = digits)
end

"""Compute center in y  of `iliadbox` within page zone.
$(SIGNATURES)
"""
function iliad_y_center(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)
    b = iliad_y_bottom(textpair, digits = digits, scale = scale, offset = offset)
    t = iliad_y_top(textpair, digits = digits)
    round((t + b) / 2, digits = digits)
end
"""
Compute area of scholion.
$(SIGNATURES)
"""
function scholion_area(textpair::BoxedTextPair; digits = 3, scale = 1.0, offset = 0)
    length = scholion_height(textpair, scale = scale, offset = offset, digits = digits)
    width = scholion_width(textpair, scale = scale, offset = offset, digits = digits)
    round(length*width, digits = digits)
end
