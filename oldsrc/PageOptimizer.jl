
"""The first optimization to be applied to a page. It will find the ideal y values for the scholia.
$(SIGNATURES)
"""
function pageOptimizerOne(pg::Int64, manuscript::Codex, dse::DSECollection)
    #Get a PageLayout object containing all the necessary data
    layout = MSPageLayout.getPageLayout(pg, manuscript, dse)

    iliad_ys = layout.pairsdimensions[2]
    scholia_hts = layout.pairsdimensions[8]

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
    println(join(value.(yval), ","))

    solution_summary(model)
end