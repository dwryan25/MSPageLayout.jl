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

    @test scholion_heights(pgdata) == [0.058, 0.057, 0.038, 0.061, 0.048, 0.03, 0.021]
    @test scholion_widths(pgdata) == [0.227, 0.696, 0.696, 0.069,0.064, 0.04, 0.054]

    @test scholion_areas(pgdata) == [0.013, 0.04, 0.026, 0.004, 0.003, 0.001, 0.001]
end


