"""HMT project data for a page.
"""
struct PageData
    pageurn::Cite2Urn
    textpairs::Vector{BoxedTextPair}
    imagezone::Cite2Urn
    folioside::String
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
    #mark as verso or recto page
    if endswith(pageurn.urn, "r")
        pagetype = "recto"
    elseif endswith(pageurn.urn, "v")
        pagetype = "verso"
    end
    if length(matchingrois) == 1
        PageData(
            pageurn,
            filter(pr -> ! isnothing(pr), boxedpairs),
            matchingrois[1][2],
            pagetype
        )
  
    else
        @warn("Couldn't find page illustration in RoI index.")
        nothing
    end

end



"""Compute top `y` value relative to page box for all *Iliad* lines on page.
$(SIGNATURES)
"""
function iliad_y_tops(pgdata::PageData; digits = 3)
    offset = pageoffset_top(pgdata, digits = digits)
    scale = pagescale_y(pgdata, digits = digits)
    raw = map(pr -> iliad_y_top(pr, digits = digits, scale = scale, offset = offset), pgdata.textpairs)
    map(f -> round(f, digits = digits), raw)
end


"""Compute top `y` value relative to page box for all scholia on page.
$(SIGNATURES)
"""
function scholion_y_tops(pgdata::PageData; digits = 3)
    offset = pageoffset_top(pgdata, digits = digits)
    scale = pagescale_y(pgdata, digits = digits)
    raw = map(pr -> scholion_y_top(pr, digits = digits, scale = scale, offset = offset), pgdata.textpairs)
    map(f -> round(f, digits = digits), raw)
end

"""Compute top 'y' value relative to page box for main scholia on pageData
$(SIGNATURES)
"""
function mainscholion_y_tops(pgdata::PageData; digits = 3)
    texts = filter(pr -> workid(pr.scholion) == "msA", pgdata.textpairs)
    offset = pageoffset_top(pgdata, digits = digits)
    scale = pagescale_y(pgdata, digits = digits)
    raw = map(pr -> scholion_y_top(pr, digits = digits, scale = scale, offset = offset), texts)
    map(f ->round(f, digits = digits), raw)
end

"""Compute height of scholia on page.
$(SIGNATURES)
"""
function scholion_heights(pgdata::PageData; digits = 3,)
    scale = pagescale_y(pgdata, digits = digits)
    offset = pageoffset_top(pgdata, digits = digits)
    raw = map(pr -> scholion_height(pr, digits = digits, scale = scale, offset = offset), pgdata.textpairs)
    map(ht -> round(ht, digits = digits), raw)
end

"""Compute width of scholia on page.
$(SIGNATURES)
"""
function scholion_widths(pgdata::PageData; digits = 3)
    scale = pagescale_x(pgdata, digits = digits)
    offset = pageoffset_left(pgdata, digits = digits)
    raw = map(pr -> scholion_width(pr, digits = digits, scale = scale, offset = offset), pgdata.textpairs)
    map(ht-> round(ht, digits = digits), raw)
end
"""Computes the area of all scholia on a page
$(SIGNATURES)
"""
function scholion_areas(pgdata::PageData; digits = 3)
    widths = scholion_widths(pgdata, digits = digits)
    lengths = scholion_heights(pgdata, digits = digits)
    if length(widths) != length(lengths)
        throw("Error: Missing or extra data in widths or lengths vector")
    else 
        n = length(widths)
    end
    areas = []
    for i in 1:n
        push!(areas, round(widths[i] * lengths[i], digits = digits))
    end
    
    return areas
end

"""Compute all the center x values for iliad text on a page
$(SIGNATURES)
"""
function iliad_x_centers(pgdata::PageData; digits = 3)
    scale = pagescale_x(pgdata, digits = digits)
    offset = pageoffset_left(pgdata, digits = digits)
    raw = map(pr -> iliad_x_center(pr, digits = digits, scale = scale, offset = offset), pgdata.textpairs)
    map(xcent -> round(xcent, digits = digits), raw)
end

"""Compute all the center x values for scholion text on a page
$(SIGNATURES)
"""
function scholion_x_centers(pgdata::PageData; digits = 3)
    scale = pagescale_x(pgdata, digits = digits)
    offset = pageoffset_left(pgdata, digits = digits)
    raw = map(pr -> scholion_x_center(pr, digits = digits, scale = scale, offset = offset), pgdata.textpairs)
    map(xcent -> round(xcent, digits = digits), raw)
end

"""Compute all the center y values for iliad text on a page
$(SIGNATURES)
"""
function iliad_y_centers(pgdata::PageData; digits = 3)
    scale = pagescale_y(pgdata, digits = digits)
    offset = pageoffset_top(pgdata, digits = digits)
    raw = map(pr -> iliad_y_center(pr, digits = digits, scale = scale, offset = offset), pgdata.textpairs)
    map(ycent -> round(ycent, digits = digits), raw)
end

"""Compute all the center y values for scholion text on a page
$(SIGNATURES)
"""
function scholion_y_centers(pgdata::PageData; digits = 3)
    scale = pagescale_y(pgdata, digits = digits)
    offset = pageoffset_top(pgdata, digits = digits)
    raw = map(pr -> scholion_y_center(pr, digits = digits, scale = scale, offset = offset), pgdata.textpairs)
    map(ycent -> round(ycent, digits = digits), raw)
end

"""Find top of page bound on documentary image.
$(SIGNATURES)
"""
function pageoffset_top(pgdata::PageData; digits = 3)
    imagefloats(pgdata.imagezone, digits = digits)[2]
end

"""Find left of page bound on documentary image
$(SIGNATURES)
"""
function pageoffset_left(pgdata::PageData; digits = 3)
    imagefloats(pgdata.imagezone, digits = digits)[1]
end

"""Find x axis scale of page bound on documentary image
$(SIGNATURES)
"""
function pagescale_x(pgdata::PageData; digits = 3)
    w = imagefloats(pgdata.imagezone, digits = digits)[3]
    round(1/w, digits = digits)
end

"""Find y axis scale of page bound on documentary image
$(SIGNATURES)
"""
function pagescale_y(pgdata::PageData; digits = 3)
    h = imagefloats(pgdata.imagezone, digits = digits)[4]
    round(1/h, digits = digits)
end



