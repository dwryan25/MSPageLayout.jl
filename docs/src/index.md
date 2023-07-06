# `MSPageLayout.jl` package

A Julia module for working with the layout of a manuscript page.

This package aims to extrapolate image data from a given manuscript page. Each verso and recto page
of the Homer multi-text manuscripts has its own set of unique references numbers which correspond to the distinct sections of text on the page. URNS are stored in plain text files of DSE triple.*
MSPageLayout uses the existing image data to calculate the dimensions of zones that reflect how the authors of the text organized a page. 

Ultimately this package provides support and pre-processing for a program that will optimize the layout of main scholia on a manuscript page according to two hypotheses. The first is that scholia are placed as close to their corresponding line as possible while remaining in top-bottom order. The second is that scholia were placed in three distinct zones based on their corresponding line's proportion to the 25 Iliad lines on each page. 

*For documentation on DSE records see https://cite-architecture.github.io/CitablePhysicalText.jl/stable/retrieval/




# Tutorial:
A user can get the following data with this package.
• The dimensions of all the Iliad lines on a page.
• The dimensions of the three zones on the top, bottom, and exterior of the Iliad text.
• A list of all the scholia and their corresponding text.
• The dimensions and centroids of each text-scholia pair.
• The area of a scholia or text box. 
• The distance between centroids of a text and scholia pair.


Packages required
using MSPageLayout
using HmtArchive
using HmtArchive.Analysis
using CitableObject
using CitableText
using CitablePhysicalText
using CitableImage
using CitableBase

```@setup tutorial
using MSPageLayout
using HmtArchive
using HmtArchive.Analysis
using CitableObject
using CitableText
using CitablePhysicalText
using CitableImage
using CitableBase
va = hmt_codices()[6] 
dse = hmt_dse()[1]
pg = va.pages[70].urn 
```
Extract the dimensions of the iliad text

```@example tutorial
iliadzone = MSPageLayout.iliadImageData(pg)
```

Get the zones of a manuscript page. See API documentation for this method for details on the return value

```@example tutorial
zones = MSPageLayout.getZones(pg)
```
Get the dimensions of each pair of scholia and text. pairsDimensions() streamlines the dimensional
data for easy use in optimization problems. See API documentation for a table on how data is organized. 

```@example tutorial
pairlist = MSPageLayout.findPairs(pg, dse = dse)
pdimensions = MSPageLayout.pairsDimensions(pairlist, dse)
```
To run an optimization algorithm on a page, you only need the function getPageLayout(). This will run all the above functions, adjust the data to scale to the page region of interest, and package it into a PageLayout object. Note that the page parameter takes an integer. Since the manuscript is a parameter the function internally retreives the page urn. 
```@example tutorial
pagedata = MSPageLayout.getPageLayout(70, va, dse)
```





