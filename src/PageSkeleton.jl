"""DataType PageSkeleton contains 4 subtypes that are all of type Vector{Float16} in x,y,w,h format. 
Each subtype is the data for the top, exterior, and bottom zones on the page plus the box encasing the iliad text only
$(SIGNATURES)
"""
struct PageSkeleton
    topzone::Vector{Float16}
    extzone::Vector{Float16}
    bottomzone::Vector{Float16}
    iliadtextzone::Vector{Float16}
end