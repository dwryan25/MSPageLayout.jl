
@testset "Test serialization of results" begin
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:55r")
    pgdata = pageData(pgurn)
    results = traditional_score_page(pgdata)

    expected = "urn:cite2:hmt:msA.v1:55r,3,6"
    @test delimited(results) == expected

    withpipes = "urn:cite2:hmt:msA.v1:55r|3|6"
    @test delimited(results, delimiter = "|") == withpipes
end


@testset "Test instantiation of `PageScore` object from delimited source" begin
    csv = "urn:cite2:hmt:msA.v1:55r,3,6"
    pgresults = resultsfromdelimited(csv)
    @test pgresults isa PageScore
    @test pgresults.pgurn == Cite2Urn("urn:cite2:hmt:msA.v1:55r")
    @test pgresults.successes == 3
    @test pgresults.failures == 6


    pipes = "urn:cite2:hmt:msA.v1:55r|3|6"
    piperesults = resultsfromdelimited(pipes, delimiter = "|")
    @test piperesults isa PageScore
    @test piperesults.pgurn == Cite2Urn("urn:cite2:hmt:msA.v1:55r")
    @test piperesults.successes == 3
    @test piperesults.failures == 6
end