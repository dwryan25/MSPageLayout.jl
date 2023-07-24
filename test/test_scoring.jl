@testset "Test scoring of page under traditional model" begin
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:55r")
    pgdata = pageData(pgurn)
    results = traditional_score_page(pgdata)
    successes = results.successes
    failures = results.failures
    mainscholia = filter(pr -> workid(pr.scholion) == "msA", pgdata.textpairs)
    @test results isa PageScore
    @test successes > 0
    @test failures > 0
    @test successes + failures == length(mainscholia)

    data = hmt_cex()
    va = hmt_codices()[6]
    #@test_broken traditional_score_manuscript(va, data) === nothing

end


@testset "Test scoring of page under Churik model" begin
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:55r")
    pgdata = pageData(pgurn)
    score = churik_score(pgdata)
    @test isa(score, PageScore)
    mainscholia_count = 9
    @test score.successes + score.failures == mainscholia_count
end