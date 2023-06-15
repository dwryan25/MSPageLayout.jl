using HmtArchive
using HmtArchive.Analysis
using CitablePhysicalText
using CitableObject
using CitableText
using CitableImage
using CitableBase
using JuMP
using HiGHS

using Documenter
using DocStringExtensions

include("TextDataHelper.jl")
include("ZoneHelper.jl")


model = Model(HiGHS.Optimizer)
