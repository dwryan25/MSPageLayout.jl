@testset "Test scoring of page under traditional model" begin
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:55r")
    pgdata = pageData(pgurn)
    results = traditional_score(pgdata)

    @test_broken results == nothing

end


@testset "Test scoring of page under Churik model" begin
    
end