# API documentation

Functions:

```@docs
MSPageLayout.iliadImageData
MSPageLayout.getZones
MSPageLayout.findPairs
MSPageLayout.getAllCentroidPairs
MSPageLayout.pairsDimensions
MSPageLayout.getPageLayout
MSPageLayout.getRoi
MSPageLayout.getCorrection
MSPageLayout.adjustZoneCoords!
MSPageLayout.adjustPairCoords!
MSPageLayout.adjustCentroidCoords!

MSPageLayout.pageOptimizerOne
```

# Functions Deep Dive
All the data used in this package comes from the Homer Multi-Text archives. 
The majority of work in this package involves relating the fields of DSE Triple's in order to narrow down the data to what is desired.

Note that the coordinates of a manuscript represent a proportion of the whole page e.g. a width of 0.45 means a text box occupies that proportion of the x-axis. 
IMPORTANT: The x and y axis stem from the top left of the manuscript image. 

e.g.
The function iliadImageData starts by retrieving all the text on the page parameter. It then filters the text by the string "tlg0012.tlg001" which identifies a urn as belonging to main text. It then parses the image urn of the first text box to get the x and y coordinates of the whole text image. In order to find the width it searches through the all the widths of each text box and finds the largest. Finally, it calculates the height by subtracting the highest y bound of the text box from the lowest y bound. 

Once you have the iliad text box and a box which encompasses all the text on the page, finding the zones is a mathematical problem. getZones() uses HmtArchive data and the new dimensions from iliadImageData() to find the dimensions of the top, exterior, and bottom zones. 

Functions that involve matching pairs of text and scholia use the archived index of commentary. The function findPairs() filters a page for all the main scholia by the string indentifier "tlg5026.msA.hmt". It then puts all the scholia that have a matching text into a vector. Other helper functions use DSE relation functions to get the coordinate data, and the rest is simple arithmetic to get the centroids of the text boxes. The centroid is important to the proximity hypothesis since the distance between a scholia and its iliad text is given by the distance between their centroids. 