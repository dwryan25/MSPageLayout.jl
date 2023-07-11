@testset "Test loading of `PageData` from internet and computation of basic layout data" begin
    # This is a good test page
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:47r")
    pgdata = pageData(pgurn)
    @test pgdata isa PageData
    expectedscholia =  7
    @test length(pgdata.textpairs) == expectedscholia


    expected_offset = 0.065
    @test pageoffset_top(pgdata) == expected_offset

    expected_tops = [0.256, 0.687, 0.724, 0.363, 0.510, 0.623, 0.307]
    @test scholion_y_tops(pgdata) == expected_tops
    expected_maintops = [0.256, 0.687, 0.724]
    @test mainscholion_y_tops(pgdata) == expected_maintops
end


