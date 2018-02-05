module Braids
# Braids.jl
# (c) 2018 Jason Victor
# Modified BSD License
# Based on algorithms in: https://dehornoy.users.lmno.cnrs.fr/Papers/Dfo.pdf
export BraidElement, BraidGroup, identity, generator, inv, ==, *, simplifybraid, dehornoyreduce, simplifybraid, braidfromintrep, prettybraid, unprettybraid, unreducedburau, randombraid, getgsampler, getmarkovsampler
include("braid.jl")
include("dehornoy.jl")
include("burau.jl")
include("sampling.jl")
end
