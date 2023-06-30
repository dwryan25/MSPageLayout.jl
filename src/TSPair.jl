
"""DataType TSPair contains two urns. One for scholia text and another for iliad text. 
    $(SIGNATURES)
"""
struct TSPair
    scholiatext::CtsUrn
    iliadtext::CtsUrn
end