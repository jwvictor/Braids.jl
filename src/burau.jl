using Nemo

# Globals for the spaces and symbols associated with the field of fractions
# of integer polynomials used as entries in the matrix space for the Burau
# representation.
# We represent the polynomials in `Z[t, t′]` as the field of fractions of
# `Z[t]` for computational simplicity. It can be trivially shown the two are
# isomorphic so, most importantly perhaps, the property remains that the
# trivial braid is represented by the identity matrix.
BurauR, Buraux = PolynomialRing(ZZ, "t")
BurauFF = FractionField(BurauR)

"""
Unreduced Burau representation for a single generator. (Helper)
"""
function unreducedburaugen(i, isinv, n, MS)
    m = MS()
    for j = 1:i-1
        m[j,j] = one(BurauFF)
    end
    if isinv
        m[i,i+1] = one(BurauR)
        m[i+1,i] = one(BurauFF) * inv(BurauFF(Buraux))
        m[i+1,i+1] = one(BurauFF) - (one(BurauFF) * inv(BurauFF(Buraux)))
    else
        m[i,i] = one(BurauFF) - BurauFF(Buraux)
        m[i+1,i] = one(BurauFF)
        m[i,i+1] = BurauFF(Buraux)
    end
    for j = i+2:n
        m[j,j] = one(BurauFF)
    end
    m
end

"""
Get the unreduced Burau representation of `b0`. This will come in the form of
a matrix with entries in the field of fractions of `Z[t]`, the ring of
polynomials with integer coefficients. If it is equal to the standard identity
matrix, then `b0` is ambient isomorphic to the trivial braid.
"""
function unreducedburau(b0::BraidElement)
    b = unprettybraid(b0)
    n = b.group.n
    MS = MatrixSpace(BurauFF, n, n)
    mats = []
    for i = 1:length(b.crossings)
        x = b.crossings[i]
        push!(mats, unreducedburaugen(x[1], x[2] < 0, n, MS))
    end
    m = MS()
    for i = 1:n
        m[i,i] = one(BurauFF)
    end
    for x in mats
        m = m * x
    end
    m
end
