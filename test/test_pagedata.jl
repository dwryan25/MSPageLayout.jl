@testset "Test loading of `PageData` from internet" begin
    # This is a good test page
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:47r")
    pgdata = pageData(pgurn)
    @test pgdata isa PageData
    expectedscholia =  7
    @test length(pgdata.textpairs) == expectedscholia
end


@testset "Test `PageData` structure" begin
    pgurn = Cite2Urn("urn:cite2:hmt:msA.v1:47r")
    
end

@testset "Test finding x, y values for a text pair" begin
    scholionu = CtsUrn("urn:cts:greekLit:tlg5026.msA.hmt:3.5") 
    scholimage = Cite2Urn("urn:cite2:hmt:vaimg.2017a:VA042RN_0043@0.13522476,0.11950207,0.60574797,0.03098202") 
    iliadu = CtsUrn("urn:cts:greekLit:tlg0012.tlg001.msA:3.1")
    iliadimage = Cite2Urn("urn:cite2:hmt:vaimg.2017a:VA042RN_0043@0.15,0.2314,0.39,0.0293")


    textpair = BoxedTextPair(
        scholionu, scholimage,
        iliadu, iliadimage
    )


end