@testset "Test finding numeric quantites on a text pair's image box" begin
    scholionu = CtsUrn("urn:cts:greekLit:tlg5026.msA.hmt:3.5") 
    scholimage = Cite2Urn("urn:cite2:hmt:vaimg.2017a:VA042RN_0043@0.13522476,0.11950207,0.60574797,0.03098202") 
    iliadu = CtsUrn("urn:cts:greekLit:tlg0012.tlg001.msA:3.1")
    iliadimage = Cite2Urn("urn:cite2:hmt:vaimg.2017a:VA042RN_0043@0.15,0.2314,0.39,0.0293")
    lineindex = 3

    textpair = BoxedTextPair(
        scholionu, scholimage,
        iliadu, iliadimage, lineindex
    )

    @test scholion_y_top(textpair) == 0.12
    @test scholion_y_bottom(textpair) ==  0.151
    @test scholion_y_center(textpair) == 0.136
    @test scholion_height(textpair) == 0.031

    @test scholion_x_left(textpair) == 0.135
    @test scholion_x_right(textpair) == 0.741
    @test scholion_x_center(textpair) == 0.303
    @test scholion_width(textpair) == 0.606


    @test iliad_y_top(textpair) == 0.231
    @test iliad_y_bottom(textpair) ==  0.26
    @test iliad_y_center(textpair) == 0.246

    @test iliad_x_left(textpair) == 0.15
    @test iliad_x_right(textpair) == 0.54
    @test iliad_x_center(textpair) == 0.345

    @test scholion_area(textpair) == 0.019
end