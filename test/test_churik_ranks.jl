@testset "Test ranking Iliad lines by relative sequence" begin
    @test MSPageLayout.iliadzone(6) == :top
    @test MSPageLayout.iliadzone(6, span = 5) == :middle
    @test MSPageLayout.iliadzone(18) == :bottom
    @test MSPageLayout.iliadzone(18, linesonpage = 26) == :middle

end

@testset "Test ranking and then scoring scholia on a page in Churik model" begin
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:55r")
    #= pgdata = pageData(pgurn)
    topcutoff = exteriorzone_y_top(pgdata)
    bottomcutoff = exteriorzone_y_bottom(pgdata)
 =#

    @test MSPageLayout.scholionzone(0.01, 0.2, 0.8) == :top
    @test MSPageLayout.scholionzone(0.5, 0.2, 0.8) == :middle
    @test MSPageLayout.scholionzone(0.9, 0.2, 0.8) == :bottom
   


end