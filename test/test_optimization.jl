@testset "Test modelling optimal placement of scholia under traditional model" begin
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:47r")
    pgdata = pageData(pgurn)

    expected_results = [-1000]
    @test_broken model_traditional_layout(pgdata) == expected_results
end
