
"""For the given page, find the optimal placement
of scholia under the assumptions of the traditional model.
Optionally specific siglum of scholia to model. If `siglum` is `nothing`, include all scholia.

Returns a Vector of `y` coordinates.
$(SIGNATURES)
"""
function model_traditional_layout(pgdata::PageData; siglum = "msA", digits = 3)
    texts = BoxedTextPair[]
    if isnothing(siglum) 
        texts = pgdata.textpairs
    else
        texts = filter(pr -> workid(pr.scholion) == siglum, pgdata.textpairs)
    end

    # `PageData` structure with texts filtered to include only scholia
    # matching `siglum`:
    filteredPage = PageData(
        pgdata.pageurn,
        texts,
        pgdata.imagezone
    )

    # Things we'll need to optimize:
    #
    # 1. y values of Iliad lines:
    iliad_ys = iliad_y_tops(filteredPage, digits = digits)
    # 2. height of scholia:
    scholia_hts = scholion_heights(filteredPage, digits = digits)
    # Use these two arrays to run optimization in JuMP!

    []
    
    
end


"""For the given page, find the optimal placement
of scholia under the assumptions of Churik's model.
Optionally specific siglum of scholia to model. If `siglum` is `nothing`, include all scholia.

$(SIGNATURES)
"""
function model_churik_layout(pgdata::PageData; siglum = "msA")
    texts = BoxedTextPair[]
    if isnothing(siglum) 
        texts = pgdata.textpairs
    else
        texts = filter(pr -> workdi(pr.scholion) == siglum, pgdata.textpairs)
    end

    #... apply model to `texts`
    []
end