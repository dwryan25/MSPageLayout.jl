@testset "Test ranking Iliad lines by relative sequence" begin
    @test MSPageLayout.iliadzone(6) == :top
    @test MSPageLayout.iliadzone(6, span = 5) == :middle
    @test MSPageLayout.iliadzone(18) == :bottom
    @test MSPageLayout.iliadzone(18, linesonpage = 26) == :middle

end

@testset "Test ranking and then scoring scholia on a page in Churik model" begin 
    @test MSPageLayout.scholionzone(0.01, 0.2, 0.8) == :top
    @test MSPageLayout.scholionzone(0.5, 0.2, 0.8) == :middle
    @test MSPageLayout.scholionzone(0.9, 0.2, 0.8) == :bottom
   
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:55r")
    pgdata = pageData(pgurn)

    scalefactor = pagescale_y(pgdata)
    offset = pageoffset_top(pgdata)
    topcutoff = exteriorzone_y_top(pgdata)
    bottomcutoff = exteriorzone_y_bottom(pgdata)

    pair1 = pgdata.textpairs[1]
    scoresmatch = MSPageLayout.churik_model_matches(pair1, scalefactor, offset, topcutoff, bottomcutoff)
    @test scoresmatch

   


end