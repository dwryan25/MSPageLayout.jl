

@testset "Test parsing image URNs" begin
    scholimage = Cite2Urn("urn:cite2:hmt:vaimg.2017a:VA042RN_0043@0.13522476,0.11950207,0.60574797,0.03098202") 

    expected3digit = [0.135, 0.12, 0.606, 0.031]
    @test MSPageLayout.imagefloats(scholimage)  == expected3digit

    expected4digit =  [0.1352, 0.1195, 0.6057, 0.031]
    @test MSPageLayout.imagefloats(scholimage, digits = 4)  == expected4digit
end