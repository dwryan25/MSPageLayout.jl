@testset "Test finding numeric quantites on a text pair's image box" begin
    scholionu = CtsUrn("urn:cts:greekLit:tlg5026.msA.hmt:3.5") 
    scholimage = Cite2Urn("urn:cite2:hmt:vaimg.2017a:VA042RN_0043@0.13522476,0.11950207,0.60574797,0.03098202") 
    iliadu = CtsUrn("urn:cts:greekLit:tlg0012.tlg001.msA:3.1")
    iliadimage = Cite2Urn("urn:cite2:hmt:vaimg.2017a:VA042RN_0043@0.15,0.2314,0.39,0.0293")


    textpair = BoxedTextPair(
        scholionu, scholimage,
        iliadu, iliadimage
    )

    @test scholion_y_top(textpair) == 0.12
    @test scholion_y_bottom(textpair) ==  0.151
    @test scholion_y_center(textpair) == 0.136
    @test scholion_height(textpair) == 0.031


    @test scholion_x_left(textpair) == 0.135
    @test scholion_x_right(textpair) == 0.741
    @test scholion_x_center(textpair) == 0.303

    @test_broken iliad_y_top(textpair) == 0.0
    @test_broken iliad_y_bottom(textpair) ==  0.0
    @test_broken iliad_y_center(textpair) == 0.0

    @test_broken iliad_x_left(textpair) == 0.0
    @test_broken iliad_x_right(textpair) == 0.0
    @test_broken iliad_x_center(textpair) == 0.0
end