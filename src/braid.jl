import Base.identity
import Base.*
import Base.inv
import Base.show
import Base.one

"""
Artin's braid group of order `n`.
"""
struct BraidGroup
    n::Int
end

"""
An element of Artin's braid group.
"""
struct BraidElement
    group::BraidGroup
    crossings::Array{Tuple{Int,Int},1}
end

"""
Alias for the identity on `g`.
"""
function identity(g::BraidGroup)
    one(g)
end

"""
The identity on `g`.
"""
function one(g::BraidGroup)
    BraidElement(g, [])
end

"""
A generator `sigma_i^sgn` of the group `g`.
"""
function generator(g::BraidGroup, i::Int, sgn::Bool)
    sgnn = sgn ? 1 : -1
    BraidElement(g, [(i % g.n, sgnn)])
end

"""
Get braid from integer encoding of generators.
"""
function braidfromintrep(g::BraidGroup, rep::Array{Int,1})
    crossings = [(abs(x), x > 0 ? 1 : -1) for x in rep]
    BraidElement(g, crossings)
end

"""
Free reduction on the braid word crossings.
"""
function simplifybraidcrossings(crossings::Array{Tuple{Int,Int},1})
    xings0 = crossings
    xings1 = []
    nchanged = 1
    # Simplify exprssion to extent possible
    while nchanged > 0
        lchanged = 0
        if length(xings0) > 1
            for i = 1:length(xings0)
                if (i < length(xings0)) && (xings0[i][1] == xings0[i+1][1]) && (xings0[i][2] == -xings0[i+1][2])
                    # In theory these should always cancel but let's check
                    newpow = xings0[i][2] + xings0[i+1][2]
                    if newpow != 0
                        push!(xings1, (xings0[i][1], newpow))
                    end
                    lchanged += 1
                elseif (i > 1) && ((xings0[i][1] != (xings0[i-1][1])) || (xings0[i][2] != -xings0[i-1][2]))
                    push!(xings1, xings0[i])
                elseif (i == 1) && xings0[i][1] != xings0[i+1][1]
                    push!(xings1, xings0[i])
                elseif (i == 1) && xings0[i][1] == xings0[i+1][1]
                    push!(xings1, xings0[i])
                end
            end
            nchanged = lchanged
            xings0 = xings1
            xings1 = []
        else
            nchanged = 0
        end
    end
    xings = filter(x -> x[2] != 0, xings0) # Remove identities and ^0s
    xings
end

"""
Free reduction on the braid word.
"""
function simplifybraid(b::BraidElement)
    BraidElement(b.group, simplifybraidcrossings(b.crossings))
end

"""
Simplify a braid word.
"""
function simplify(b::BraidElement)
    prettybraid(BraidElement(b.group, simplifybraidcrossings(b.crossings)))
end

"""
Multiplication of braid words.
"""
function *(b1::BraidElement, b2::BraidElement)
    xings0 = cat(1, b1.crossings, b2.crossings)
    xings = simplifybraidcrossings(xings0)
    prettybraid(BraidElement(b1.group, xings))
end

"""
Finds crossing of lowest index in `b`.
"""
function lowestindex(b::BraidElement)
    if length(b.crossings) == 0
        0
    else
        minimum([x[1] for x in b.crossings])
    end
end

"""
Determines whether `b` is reduced in the sense of Dehornoy.
"""
function isreduced(b::BraidElement)
    minidx = lowestindex(b)
    genpows = [q[2] for q in find(z -> z[1] == minidx, b.crossings)]
    (minimum(genpows) < 0) == (maximum(genpows) < 0)
end

"""
Get the inverse of `b`.
"""
function inv(b::BraidElement)
    newxings = [(q[1], -1 * q[2]) for q in b.crossings[length(b.crossings):-1:1]]
    BraidElement(b.group, newxings)
end

"""
Convert `b` to a string.
"""
function Base.show(io::IO, b0::BraidElement)
    b = prettybraid(b0)
    getexp(i) = (i == 1 ? "" : (i == -1 ? "′" : string("^", i)))
    if length(b.crossings) > 0
        sx = [string("σ_", string(i[1]), getexp(i[2])) for i in b.crossings]
        s = join(sx, "⋅")
        #s = s[length("String")+1:end] # Hackety hack
        print(io, s)
    else
        print(io, "ϵ")
    end
end

"""
Convert representation from pure generators to powers of generators.
"""
function prettybraid(b::BraidElement)
    if length(b.crossings) == 0
        return b
    end
    c = []
    curexp = [b.crossings[1][2]]
    curbase = b.crossings[1][1]
    for i in 2:length(b.crossings)
        x = b.crossings[i]
        if x[1] == curbase
            push!(curexp, x[2])
        else
            push!(c, (curbase, sum(curexp)))
            curbase = x[1]
            curexp = [x[2]]
        end
    end
    push!(c, (curbase, sum(curexp)))
    simplifybraid(BraidElement(b.group, c))
end

"""
Convert representation from powers of generators to pure generators.
"""
function unprettybraid(b::BraidElement)
    c = []
    for x in b.crossings
        sgn = x[2] < 0 ? -1 : 1
        for i = 1:abs(x[2])
            push!(c, (x[1], sgn))
        end
    end
    simplifybraid(BraidElement(b.group, c))
end
