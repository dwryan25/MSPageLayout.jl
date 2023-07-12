@testset "Test finding the width of exterior zones on a give page" begin
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:55r")
    pgdata = pageData(pgurn)

    extwidth = exteriorzone_width(pgdata)
    expected = -1.0
    @test extwidth isa Int64
    @test_broken extwdith == expected
end