@testset "Test loading data from HMT archive" begin
    # List of pages in VenetusA manuscript
    vapages = nothing
    @test_broken vapages isa Vector{Codex}

end

@testset "Test ZoneHelper.jl functions" begin
    pg  = Cite2Urn("urn:cite2:hmt:msA.v1:34r")
    zones = MSPageLayout.getZones(pg)
    @test length(zones) == 3
    for z in zones
        @test length(z) == 4
    end
    @test zones isa Vector{Vector{Float16}}
    for zone in zones
        @test zone isa Vector{Float16}
    end
end

@testset "Test TextDataHelper functions" begin
    pg = Cite2Urn("urn:cite2:hmt:msA.v1:34r")
    pairs = findPairs(pg)

    @test isa Vector
    @test
end