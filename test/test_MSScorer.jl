@testset "Test top-level Scoring functions" begin
    proxscore = manuscriptProximityScore(newpages)
    @test isaVector
    @test for score in proxscore
            score isa PageScore
          end
    churikscore = manuscriptChurikScore(newpages)
    @test isaVector
    @test for score in proxscore
            score isa PageScore
          end
end