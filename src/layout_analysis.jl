
"""For the given page, find the optimal placement
of scholia under the assumptions of the traditional model.
Optionally specific siglum of scholia to model. If `siglum` is `nothing`, include all scholia.

Returns a Vector of `y` coordinates.
$(SIGNATURES)
"""
function model_traditional_layout(pgdata::PageData; siglum = "msA")
    []
end


"""For the given page, find the optimal placement
of scholia under the assumptions of Churik's model.
Optionally specific siglum of scholia to model. If `siglum` is `nothing`, include all scholia.

$(SIGNATURES)
"""
function model_churik_layout(pgdata::PageData; siglum = "msA")
    []
end