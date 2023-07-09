
"""DataType TSPair contains two urns. One for scholia text and another for iliad text. 
Parameters are required. No default constructor. 
```@example
scholiaurn = "urn:cts:greekLit:tlg5026.msA.hmt:2.597"
texturn = "urn:cts:greekLit:tlg0012.tlg001.msA:2.488"
p = TSPair("urn:cts:greekLit:tlg5026.msA.hmt:2.597", "urn:cts:greekLit:tlg0012.tlg001.msA:2.488")
```
    $(SIGNATURES)
"""
struct TSPair
    iliadtext::CtsUrn
    scholiatext::CtsUrn
end