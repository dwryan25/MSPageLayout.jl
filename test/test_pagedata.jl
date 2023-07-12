@testset "Test loading of `PageData` from internet and computation of basic layout data" begin
    # This is a good test page
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:47r")
    pgdata = pageData(pgurn)
    @test pgdata isa PageData
    expectedscholia =  7
    @test length(pgdata.textpairs) == expectedscholia


    expected_offset = 0.065
    expected_scale = 1.156
    @test pageoffset_top(pgdata) == expected_offset
    @test pagescale_y(pgdata) == expected_scale
    expected_tops = [0.296, 0.794, 0.837, 0.420, 0.590, 0.720, 0.355]
    @test scholion_y_tops(pgdata) == expected_tops
    expected_maintops = [0.296, 0.794, 0.837]
    @test mainscholion_y_tops(pgdata) == expected_maintops

    @test scholion_heights(pgdata) == [0.058, 0.057, 0.039, 0.062, 0.049, 0.03, .021]
    @test_broken scholion_widths(pgdata) == []

    @test_broken scholion_areas(pgdata) == []
end


