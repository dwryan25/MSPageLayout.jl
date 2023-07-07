"""Gather Iliad image coordinates for a given page.If no 
dse parameter supplied then retrieve it
$(SIGNATURES)
"""
function iliadImageData(pg::Cite2Urn, dse::DSECollection)
    alltext = textsforsurface(pg, dse)
    iliadtext = filter(txt->startswith(workcomponent(txt), "tlg0012.tlg001"), alltext)
    finalcoords = Float16[]
    # Get coords of first and last text box
    imglist = imagesfortext(iliadtext[1], dse)
    imglist2 = imagesfortext(iliadtext[length(iliadtext)], dse)
    topcoords = split(subref(imglist[1]), ",")
    bottomcoords = split(subref(imglist2[1]), ",")
    # Push x and y to result
    push!(finalcoords, parse(Float16, topcoords[1]))
    push!(finalcoords, parse(Float16,topcoords[2]))
    # Get the max width
    widths = Float16[]
    for texturn in iliadtext
        imgStats = imagesfortext(texturn, dse)
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

"""Gets the proposed zones for a recto page of the Venetus A manuscript. Helper function
for getZones(). Returns a vector of vectors containing data on each zone. 
"""
function scholiaZonesRecto(iliadData::Vector{Float16}, roi::Vector{Float16})
    #get roi
    wholepage = roi
    # Calculates zone data
    hprime = wholepage[4]
    h = iliadData[4]
    htop = iliadData[2]-wholepage[2]
    hbottom = hprime - (h+htop)
    topzonedata = [wholepage[1], wholepage[2], wholepage[3], htop]
    extzonedata = Float16[iliadData[1]+iliadData[3], iliadData[2], wholepage[3]-iliadData[3]-(iliadData[1]-wholepage[1]), iliadData[4]]
    bottomzonedata = Float16[wholepage[1], iliadData[2]+iliadData[4], wholepage[3], hbottom]

    allzonedata = [topzonedata, extzonedata, bottomzonedata]

    return allzonedata
end
"""Gets the proposed zones for a verso page of the Venetus A manuscript. This function
returns a vector of vectors containing the data on each zone. It is a helper function for
getZones()
"""
function scholiaZonesVerso(pg::Cite2Urn, iliadData::Vector{Float16}, roi::Vector{Float16}, dse::DSECollection)
    #get roi
    wholepage = roi
    # get text and intermarginal scholia
    text = textsforsurface(pg, dse)
    imscholia = filter(txt->startswith(workcomponent(txt), "tlg5026.msAim"), text)
    # Set immaxwidth to 0.055 as default if no imscholia are on the page
    if isempty(imscholia)
        immaxwidth = 0.055
    end
    # Find max width of imscholia to bridge gap between exterior and text zone
    imwidths = Float16[]
    for i in eachindex(imscholia)
        imgStats = imagesfortext(imscholia[i], dse)
        coords = split(subref(imgStats[1]), ",")
        push!(imwidths, parse(Float16,coords[3]))
    end
    # Calculate zone data
    immaxwidth = maximum(imwidths)
    htop = iliadData[2] - wholepage[2]
    hbot = wholepage[4] - (iliadData[4] + htop)
    topzone = [wholepage[1], wholepage[2], wholepage[3], htop]
    extzone = [wholepage[1], iliadData[2], wholepage[3] - (iliadData[3] + immaxwidth), iliadData[4]]
    bottomzone = [wholepage[1], iliadData[2]+iliadData[4], wholepage[3], hbot]
    # order goes top, exterior, bottom
    allzonedata = [topzone, extzone, bottomzone]
    return allzonedata

end


"""Get the proposed scholia zones of a recto or verso page. 
Finds out whether a page is verso or recto and then calls helper functions
$(SIGNATURES)
"""
function getZones(pg::Cite2Urn, rois::PageImageZone; dse = nothing)
    dse = if isnothing(dse)
        hmt_dse()[1]
    else 
        dse
    end
    roi = MSPageLayout.getRoi(pg, rois)
    iliadData = MSPageLayout.iliadImageData(pg, dse)
    if endswith(pg.urn, "r")
        scholiazones = scholiaZonesRecto(iliadData, roi)
    elseif endswith(pg.urn, "v")
        scholiazones = scholiaZonesVerso(pg, iliadData, roi, dse)
    end

    pagezones = [scholiazones[1], scholiazones[2], scholiazones[3], iliadData]
    return pagezones
end

"""This function returns the correction needed to scale all the data on a page to a 0.0 1.0 within 
the text box that encloses the page. Essentially, it gets the values needed to discard the parts of
the photo that do not contain the actual manuscript. It takes a page urn as its parameter and returns 
a vector containing the x value correction and y value correction in the format [x,y].
Extremely useful in relating zone and text data as this correction must be applied to all the data on
a page before calling optimization or scoring functions. 
$(SIGNATURES)
"""
function getCorrection(pg::Cite2Urn, rois::PageImageZone)
    #Get the page box of the image
    wholepage = MSPageLayout.getRoi(pg, rois)
    #Get the correction 
    xcor = wholepage[1]
    ycor = wholepage[2]
    wcor = 1/wholepage[3]
    hcor= 1/wholepage[4]
    return [xcor, ycor, wcor, hcor]
end

"""Gets the region of interest of a given page. Since the roi index is not parallel to page index, 
the function searches through the roi index to find the matching page urn. 
$(SIGNATURES)
"""
function getRoi(pg::Cite2Urn, rois::PageImageZone)
    local roi
    for i in eachindex(rois.index)
        if rois.index[i][1] == pg
            roi = split(subref(rois.index[i][2]), ",")
        end
    end
    roi = map(x->parse(Float16, x), roi)    
    return roi
end

function adjustZoneCoords!(zones::Vector{Vector{Float16}}, correction::Vector{Float16})
    #x and y vals minus correction
    for i = 1:4
        zones[i][1] = map(x->x-correction[1], zones[i][1])
        zones[i][2] = map(y->y-correction[2], zones[i][2])
     end
     #w and h vals plus correction
     for i = 1:4
         zones[i][3] = map(w->w*correction[3], zones[i][3])
         zones[i][4] = map(h->h*correction[4], zones[i][4])
     end
end