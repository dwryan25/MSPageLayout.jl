"""Gather Iliad image coordinates for a given page.If no 
dse parameter supplied then retrieve it
$(SIGNATURES)
"""

function iliadImageData(pg::Cite2Urn, dse = nothing)
    dserecords = if isnothing(dse)
        hmt_dse()[1]
    else 
        dse
    end
    alltext = textsforsurface(pg, dserecords)
    iliadtext = filter(txt->startswith(workcomponent(txt), "tlg0012.tlg001"), alltext)
    finalcoords = Float16[]
    # Get coords of first and last text box
    imglist = imagesfortext(iliadtext[1],dserecords)
    imglist2 = imagesfortext(iliadtext[length(iliadtext)], dserecords)
    topcoords = split(subref(imglist[1]), ",")
    bottomcoords = split(subref(imglist2[1]), ",")
    # Push x and y to result
    push!(finalcoords, parse(Float16, topcoords[1]))
    push!(finalcoords, parse(Float16,topcoords[2]))
    # Get the max width
    widths = Float16[]
    for texturn in iliadtext
        imgStats = imagesfortext(texturn, dserecords)
        coords = split(subref(imgStats[1]), ",")
        push!(widths, parse(Float16,coords[3]))
    end

    
    totalWidth = maximum(widths)

    # Get max height from difference of bottom and top y coords
    totalHeight = (parse(Float16, bottomcoords[2]) + parse(Float16, bottomcoords[4])) - parse(Float16, topcoords[2])  
    # Push height and width to result vector
    push!(finalcoords, totalWidth)
    push!(finalcoords, totalHeight)

    return finalcoords
end

"""Gets the proposed zones for page 70recto of the VenetusA. This is a test function that will
later be applied to all pages when the appropriate images are archived
Page 70 image urn: urn:cite2:hmt:vaimg.2017a:VA034RN_0035@0.1533,0.09696,0.6511,0.7725
"""
function scholiaZonesRecto(pg::Cite2Urn, dse= nothing)
    dserecords = if isnothing(dse)
        hmt_dse()[1]
    else 
        dse
    end
    iliadData = iliadImageData(pg)
    alltext = split(subref(Cite2Urn("urn:cite2:hmt:vaimg.2017a:VA034RN_0035@0.1533,0.09696,0.6511,0.7725")), ",")
    alltext = map(x->parse(Float16, x), alltext)

    # Calculates zone data
    hprime = alltext[4]
    h = iliadData[4]
    htop = iliadData[2]-alltext[2]
    hbottom = hprime - (h+htop)
    topzonedata = [alltext[1], alltext[2], alltext[3], htop]
    extzonedata = Float16[iliadData[1]+iliadData[3], iliadData[2], alltext[3]-iliadData[3], iliadData[4]]
    bottomzonedata = Float16[alltext[1], iliadData[2]+iliadData[4], alltext[3], hbottom]

    allzonedata = [topzonedata, extzonedata, bottomzonedata]

    return allzonedata
end
"""Gets the proposed zones for page 15verso of the VenetusA. This is for testing purposes
and will apply to all pages when the appropriate images are archived.
page 15verso surface urn: urn:cite2:hmt:vaimg.2017a:VA015VN_0517
"""
function scholiaZonesVerso(pg::Cite2Urn, dse = nothing)
    dserecords = if isnothing(dse)
        hmt_dse()[1]
    else 
        dse
    end
    # gather info on page
    iliadData = iliadImageData(pg)
    alltext = split(subref(Cite2Urn("urn:cite2:hmt:vaimg.2017a:VA015VN_0517@0.2132,0.1051,0.6361,0.6766")), ",")
    alltext = map(x->parse(Float16, x), alltext)

    text = textsforsurface(hmt_codices()[6].pages[33].urn, dserecords)
    imscholia = filter(txt->startswith(workcomponent(txt), "tlg5026.msAim"), text)
    # Set immaxwidth to 0.055 as default if no imscholia are on the page
    if isempty(imscholia)
        immaxwidth = 0.055
    end
    # Find max width of imscholia to bridge gap between exterior and text zone
    imwidths = Float16[]
    for i in eachindex(imscholia)
        imgStats = imagesfortext(imscholia[i], dserecords)
        coords = split(subref(imgStats[1]), ",")
        push!(imwidths, parse(Float16,coords[3]))
    end
    # Calculate zone data
    immaxwidth = maximum(imwidths)
    htop = iliadData[2] - alltext[2]
    hbot = alltext[4] - (iliadData[4] + htop)
    topzone = [alltext[1], alltext[2], alltext[3], htop]
    extzone = [alltext[1], iliadData[2], alltext[3] - (iliadData[3] + immaxwidth), iliadData[4]]
    bottomzone = [alltext[1], iliadData[2]+iliadData[4], alltext[3], hbot]

    allzonedata = [topzone, extzone, bottomzone]
    return allzonedata

end


"""Get the proposed scholia zones of a recto or verso page. 
Finds out whether a page is verso or recto and then calls helper functions
"""
function getZones(pg::Cite2Urn)
    if endswith(pg.urn, "r")
        scholiaZonesRecto(pg)
    elseif endswith(pg.urn, "v")
        scholiaZonesVerso(pg)
    end
end


