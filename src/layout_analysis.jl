
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
    # Use these two arrays to run optimization in JuMP
    n = length(scholia_hts)
    totals = []
    for i in 1:n
        push!(totals, sum(scholia_hts[1:i]))
    end
    #= 
    Constraints: 
    - the domain of possible y values is from 0 to 1 inclusive
    - the y value of each note is < than the cumulative heights of the notes
    Objective:
    - minimize the distance from note to iliad line
    =#
    model = Model(HiGHS.Optimizer)
    @variable(model, yval[i = 1:n])
    @constraint(model, domainlimits, 0 .<= yval .<= 1)
    @constraint(model, cumulativeconstraint, yval .>= totals)
    
    @objective(model, Min, sum(yval[i] - iliad_ys[i] for i in 1:n))

    optimize!(model)
    solution_summary(model)
    stringvalue = join(round.(value.(yval), digits = digits), ",")
    opt_ys= split(stringvalue, ",")
    opt_ys= map(x->round(parse(Float64, x), digits = digits), opt_ys)
    return opt_ys
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