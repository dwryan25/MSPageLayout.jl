@testset "Test TextDataHelper functions" begin
    #findPairs()
    dse = hmt_dse()[1]
    rois = hmt_pagerois()
    pg = Cite2Urn("urn:cite2:hmt:msA.v1:34r")
    pairs = findPairs(pg, dse = dse)
    @test pairs isa Vector
    @test for pair in pairs 
            if pair isa TSPair end
        end
    #getAllCentroidPairs()
    centroids = getAllCentroidPairs(pairs, dse)
    @test centroids isa Vector
    @test for centroid in centroids
            if centroid isa Vector{Float16}end
        end
    #pairsDimensions()
    pdimensions = pairsDimensions(pairs, dse)
    @test pdimensions isaVector
    @test for data in pdimensions
            if data isa Vector{Float16}end
            for i in data
                if i <= 1 end
            end    
        end
    #adjustPairCoords()
    correction = getCorrection(pg, rois)
    adjustPairCoords!(pdimensions, correction)
    @test for data in pdimensions
            for i in data
                if i <= 1 end
            end
        end
    #adjustCentroidCoords()
    adjustCentroidCoords(centroids, correction)
    @test for centroidpair in centroids
        for i in centroidpair
            if i <= 1 end
        end
    end

end