import Base.==

"""
Determine if `p, q` is a handle for `braid0`.
"""
function dehornoyishandle(braid0::BraidElement, p::Int, q::Int)::Bool
    braid = simplifybraid(braid0)
    if (braid.crossings[p][2] + braid.crossings[q][2] == 0) && (braid.crossings[p][1] == braid.crossings[q][1])
        v = braid.crossings[(p+1):(q-1)]
        j = braid.crossings[p][1]
        jp1 = filter(x -> x[1] == (j+1), v)
        jp1pos = filter(x -> x[2] > 0, jp1)
        jp1neg = filter(x -> x[2] < 0, jp1)
        if length(jp1pos) > 0 && length(jp1neg) > 0
            return false
        end
        for k in v
            if !(k[1] < (j-1) || k[1] > j) # Original
            #if !(k[1] < (j-1) || k[1] > (j+1)) # Ambiguity in the paper
                return false
            end
        end
        true
    else
        false
    end
end

"""
Find the first handle in `braid0` if one exists.
"""
function dehornoyfirsthandle(braid0::BraidElement)::Union{Tuple{Int,Int},Void}
    braid = simplifybraid(braid0)
    #for q = length(braid.crossings):-1:2
    for q = 2:length(braid.crossings)
    #for p = 1:(length(braid.crossings) - 1)
        #for q = (p+1):length(braid.crossings)
        #for p = 1:(q-1)
        for p = (q-1):-1:1
            if dehornoyishandle(braid0, p, q)
                return (p, q)
            end
        end
    end
    return nothing
end

"""
Reduce according to the alphabetic homomorphism of Dehornoy.
"""
function dehornoyalphareduce(braid0::BraidElement, handlep::Int, handleq::Int)::BraidElement
    nh = []
    j, e = braid0.crossings[handlep]
    for s in braid0.crossings[handlep:handleq]
        idx, ex = s
        if (idx != j) && (idx != (j+1))
            push!(nh, s)
        elseif idx == (j+1)
            push!(nh, (idx, -1*e))
            push!(nh, (j, ex))
            push!(nh, (idx, e))
        end
    end
    nw = cat(1, braid0.crossings[1:handlep-1], nh, braid0.crossings[handleq+1:end])
    b = BraidElement(braid0.group, nw)
    simplifybraid(b)
end

"""
Reduce according to the algorithm of Dehornoy.
"""
function dehornoyreduce(braid0::BraidElement)::BraidElement
    braid = unprettybraid(simplifybraid(braid0))
    while true
        handle = dehornoyfirsthandle(braid)
        if handle == nothing
            return prettybraid(simplifybraid(braid))
        else
            p, q = handle
            braid = dehornoyalphareduce(braid, p, q)
        end
    end
end

"""
Is a braid empty?
"""
function isempty(b::BraidElement)::Bool
    length(b.crossings) == 0
end

"""
Are two braids equal (in terms of ambient isotopy)?
"""
function ==(b1::BraidElement, b2::BraidElement)
    isempty(dehornoyreduce(b1 * inv(b2)))
end
