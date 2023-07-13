@testset "Test scoring of page under traditional model" begin
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:55r")
    pgdata = pageData(pgurn)
    results = traditional_score(pgdata)
    successes = results.successes
    failures = results.failures
    mainscholia = filter(pr -> workid(pr.scholion) == "msA", pgdata.textpairs)
    @test results isa PageScore
    @test successes > 0
    @test failures > 0
    @test successes + failures == length(mainscholia)

end


@testset "Test scoring of page under Churik model" begin
    
end