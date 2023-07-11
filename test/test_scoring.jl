@testset "Test scoring of page under traditional model" begin
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:55r")
    pgdata = pageData(pgurn)
    results = traditional_score(pgdata)
    successes = results.successes
    failures = results.failures
    @test_broken results isa PageScore
    @test_broken successes < 0
    @test_broken failures < 0
    @test_broken successes + failures == length(pgdata.textpairs)

end


@testset "Test scoring of page under Churik model" begin
    
end