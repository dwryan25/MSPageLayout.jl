@testset "Test loading of `PageData` from internet" begin
    # This is a good test page
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:47r")
    pgdata = pageData(pgurn)
    @test pgdata isa PageData
    expectedscholia =  7
    @test length(pgdata.textpairs) == expectedscholia
end


@testset "Test `PageData` structure" begin
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:47r")
    
end