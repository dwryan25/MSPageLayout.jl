"""This is the complete package of all the adjusted data for a manuscript page. The function 
    adjustCoords() creates a new variable of this type containing all the necessary data. 
    Top level functions which work with the data on a page will call
    getPageLayout() in order to get the necessary data and package it into one datatype
"""
struct PageLayout
    zones::PageSkeleton
    centroidlist::Vector{Vector{Float16}}
    pairsdimensions::Vector{Vector{Float16}}
end