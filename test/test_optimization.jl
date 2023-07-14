@testset "Test modelling optimal placement of scholia under traditional model" begin
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:95r")
    pagedata = pageData(pgurn)

    expected_results = [-1000]
    actual_results = model_traditional_layout(pagedata, siglum = nothing)
    @test_broken actual_results == expected_results
   
    @test typeof(actual_results) == Vector{Float64}
    @test length(actual_results) == length(pagedata.textpairs)


    @test_broken secondmodel_traditional_layout(pagedata) == []
    
end
