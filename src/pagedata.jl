"""HMT project data for a page.
"""
struct PageData
    pageurn::Cite2Urn
    textpairs::Vector{BoxedTextPair}
    imagezone::Cite2Urn
end

"""Construct a `PageData` object for the
page identified by `pageurn`.  Optionally include
a full HMT project dataset in the `data` parameter.
Return `nothing` if no page region is available for an image.
$(SIGNATURES)
"""
function pageData(pageurn::Cite2Urn; data = nothing)::Union{PageData, Nothing}
    hmtdata = isnothing(data) ? hmt_cex() : data
    dse = hmt_dse(hmtdata)[1] 
    textpassages = textsforsurface(pageurn, dse)
    allcommentary = hmt_commentary(hmtdata)[1]
  
    scholia = filter(psg -> startswith(workcomponent(psg), "tlg5026"), textpassages)
    iliadlines = filter(psg -> startswith(workcomponent(psg), "tlg0012.tlg001"), textpassages)
    iliadstrings = map(ln -> string(ln), iliadlines)
    boxedpairs = map(scholia) do s
        iliadmatches = filter(pr -> pr[1] == s, allcommentary.commentary)
        if length(iliadmatches) == 1
            iliad = iliadmatches[1][2]
            lineindex = findfirst(isequal(string(iliad)), iliadstrings)

            schimagematches = imagesfortext(s, dse)
            ilimagematches = imagesfortext(iliad, dse)

            if length(schimagematches) == 1 && length(ilimagematches) == 1
                BoxedTextPair(
                    s,
                    schimagematches[1],
                    iliad,
                    ilimagematches[1],
                    lineindex
                )

            else
                @warn("Failed to find images for scholion $(s) and Iliad line $(iliad).")
                nothing
            end
        else
            @warn("No Iliad match for scholion $(s).")
            nothing
        end
    end

    allpagerois = hmt_pagerois(hmtdata)
    matchingrois = filter(pr -> pr[1] == pageurn, allpagerois.index)
    if length(matchingrois) == 1
        PageData(
            pageurn,
            filter(pr -> ! isnothing(pr), boxedpairs),
            matchingrois[1][2]
        )
  
    else
        @warn("Couldn't find page illustratoin in RoI index.")
        nothing
    end

end



"""Compute top `y` value relative to page box for all *Iliad* lines on page.
$(SIGNATURES)
"""
function iliad_y_tops(pgdata::PageData; digits = 3)
    offset = pageoffset_top(pgdata, digits = digits)
    raw = map(pr -> iliad_y_top(pr, digits = digits) - offset, pgdata.textpairs)
    map(f -> round(f, digits = digits), raw)
end


"""Compute top `y` value relative to page box for all scholia on page.
$(SIGNATURES)
"""
function scholion_y_tops(pgdata::PageData; digits = 3)
    offset = pageoffset_top(pgdata, digits = digits)
    raw = map(pr -> scholion_y_top(pr, digits = digits) - offset, pgdata.textpairs)
    map(f -> round(f, digits = digits), raw)
end


"""Compute height of scholia on page.
$(SIGNATURES)
"""
function scholion_heights(pgdata::PageData; digits = 3)
    raw = map(pr -> scholion_height(pr, digits = digits), pgdata.textpairs)
    map(ht -> round(ht, digits = digits), raw)
end

"""Find top of page bound on documentary image.
$(SIGNATURES)
"""
function pageoffset_top(pgdata::PageData; digits = 3)
    imagefloats(pgdata.imagezone, digits = digits)[2]
end







