
"""Extract region-of-interest string from an image URN, and convert to a Vector of `Float64`s, rounded
to `digits` significant digits.
$(SIGNATURES)
"""
function imagefloats(imgu::Cite2Urn; digits = 3)::Union{Vector{Float64}, Nothing}
    parts = split(subref(imgu),",")
    if length(parts) == 4
        floats = map(roi -> parse(Float64, roi), parts)
        map(num -> round(num, digits=digits), floats)
    else
        nothing
        #throw(ArgumentError("""Invalid region of interest in urn `$(imgu)`:  expression must have four comma-separated parts.""")) 
    end
end