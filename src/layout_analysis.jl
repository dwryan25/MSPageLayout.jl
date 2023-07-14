
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
        pgdata.imagezone,
        pgdata.folioside
    )

    # Things we'll need in order to optimize:
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

function secondmodel_traditional_layout(pgdata::PageData, new_ys::Vector{Float64}; siglum = "msA", digits = 3)
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
    #Things we'll need in order to optimize:
    #1. iliad line center x values
    iliad_x_centroids = iliad_x_centers(pgdata)
    iliad_y_centroids = iliad_y_centers(pgdata)
    #2. scholia areas
    areas = scholion_areas(pgdata)
    
    #Constraints:
    # 1. If the corresponding y is less than the top of the exterior zone and greater than the bottom,
    #    then the  x value lies between 0 and the width of the whole page.
    # 2. If the corresponding y value is in the middle section, differentiate between verso and recto.
    # 3. For recto pages x is between the width of the exterior zone and the width of the whole page
    # 4. For verso pages x is between 0 and the width of th exterior zone

    # Objective: Find minimum of scholia and iliad centroid distance
    
end
"""Recursive helper function for secondmodel_traditional_layout. Individually optimizes
each scholion and uses the return value as part of the constraints.
"""
function secondmodel_helper(iliad__centroids::Vector{Float64}, iliad_y_centroids::Vector{Float64}, areas::Vector{Float64}, i::Int64)
    #base case is the first text-scholion pair 
    if i = 0
        return 0
    else
        model = Model(HiGHS.Optimizer)
        @variable(model, sch_y[i], sch_x[i], sch_h[i])

        @constraint(model, domainlimits, begin 0 <= schy_y <= 1, 0 <= sch_x <= 1 end)
        @constraint(model, cumulativeconstraint, sch_y >= secondmodel_helper(iliad_x_centroids, iliad_y_centroids, areas, i-1))

        @objective(model, Min, )
    end
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