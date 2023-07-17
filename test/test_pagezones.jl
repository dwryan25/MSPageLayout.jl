@testset "Test finding the width of exterior zones on a give page" begin
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:55r")
    pgdata = pageData(pgurn)

    extwidth = exteriorzone_width(pgdata)
    expected_width = 0.355
    @test extwidth == expected_width

    expected_top = 0.224
    exterior_top = exteriorzone_y_top(pgdata)
    @test exterior_top == expected_top

    expected_bottom = 0.7
    exterior_bottom = exteriorzone_y_bottom(pgdata)
    @test exterior_bottom == expected_bottom
end