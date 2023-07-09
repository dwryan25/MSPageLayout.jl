@testset "Test loading of `PageData` from internet and computation of basic layout data" begin
    # This is a good test page
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:47r")
    pgdata = pageData(pgurn)
    @test pgdata isa PageData
    expectedscholia =  7
    @test length(pgdata.textpairs) == expectedscholia


    expected_offset = 0
    @test_broken pageoffset_top(pgdata) == expected_offset

    expected_tops = []
    @test_broken scholion_y_tops(pgdata) == expected_tops
end


