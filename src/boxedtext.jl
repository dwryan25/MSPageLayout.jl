"""A scholion paired with the *Iliad* line it comments on.
Each text passage has a corresponding image with region of interest.
"""
struct BoxedTextPair
    scholion::CtsUrn
    scholionbox::Cite2Urn
    iliadline::CtsUrn
    iliadbox::Cite2Urn
end


"""Compute left edge of `scholionbox` within page zone.
$(SIGNATURES)
"""
function scholion_x_left(textpair::BoxedTextPair)
    CitableImage.roiFloats(textpair.scholionbox)[1]
    
end