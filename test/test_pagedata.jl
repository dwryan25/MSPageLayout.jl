@testset "Test loading of `PageData` from internet" begin
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:32r")
    pgdata = pageData(pgurn)
    @test pgdata isa PageData
end


@testset "Test `PageData` structure" begin
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:32r")
    
end