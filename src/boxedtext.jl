"""A scholion paired with the *Iliad* line it comments on.
Each text passage has a corresponding image with region of interest.
"""
struct BoxedTextPair
    scholion::CtsUrn
    scholionbox::Cite2Urn
    iliadline::CtsUrn
    iliadbox::Cite2Urn
end


"""Compute left edge of `scholionbox`.
$(SIGNATURES)
"""
function scholion_x_left(textpair::BoxedTextPair; digits = 3)
    imagefloats(textpair.scholionbox, digits = digits)[1]
end

"""Compute right edge of `scholionbox` within page zone.
$(SIGNATURES)
"""
function scholion_x_right(textpair::BoxedTextPair; digits = 3)
    floats = imagefloats(textpair.scholionbox, digits = digits)
    floats[1] + floats[3]
end


"""Compute center in x  of `scholionbox` within page zone.
$(SIGNATURES)
"""
function scholion_x_center(textpair::BoxedTextPair; digits = 3)
    r = scholion_x_right(textpair, digits = digits)
    l = scholion_x_left(textpair, digits = digits)
    (r - l) / 2
end

"""Compute top edge of `scholionbox`.
$(SIGNATURES)
"""
function scholion_y_top(textpair::BoxedTextPair; digits = 3)
    imagefloats(textpair.scholionbox, digits = digits)[2]
end

"""Compute bottom edge of `scholionbox` within page zone.
$(SIGNATURES)
"""
function scholion_y_bottom(textpair::BoxedTextPair; digits = 3)
    floats = imagefloats(textpair.scholionbox, digits = digits)
    floats[2] + floats[4]
end


"""Compute center in y  of `scholionbox` within page zone.
$(SIGNATURES)
"""
function scholion_y_center(textpair::BoxedTextPair; digits = 3)
    b = scholion_x_bottom(textpair, digits = digits)
    t = scholion_x_top(textpair, digits = digits)
    (t - b) / 2
end