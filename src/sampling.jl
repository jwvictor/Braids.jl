
# EXPERIMENTAL: random braid generation
# These functions are the subject of my ongoing research. They are far from
# finalized. Use caution.

"""
Draw a uniform random braid.
"""
function randombraid(maxlen::Int, g::BraidGroup)
    l = convert(Int, floor(rand() * maxlen)) + 1
    x = Tuple{Int,Int}[]
    for i = 1:l
        idx = convert(Int, floor((g.n - 1) * rand())) + 1
        expt = rand() > 0.5 ? 1 : -1
        push!(x, (idx, expt))
    end
    simplifybraid(BraidElement(g, x))
end

"""
Sample a random braid given the draw function `f`, where `f` should return
null to terminate the braid, and a nonempty `Nullable{BraidElement}` otherwise.
"""
function randombraid(f::Function, g::BraidGroup)
    c = one(g)
    x = convert(Nullable{BraidElement}, f())
    while !isnull(x)
        c = c * get(x)
        x = convert(Nullable{BraidElement}, f())
    end
    c
end

"""
Get a sampler based on a random walk over strands with equal probability of
passing over and under. Stops with probability `dprob` and switches
strands with probability `sprob`.
"""
function getmarkovsampler(g::BraidGroup, sprob::Float64, dprob::Float64)
    cur = 1
    () -> begin
        if rand() < dprob
            return Nullable{BraidElement}()
        end
        if rand() < sprob
            if cur == (g.n - 1)
                ir = -1 * cur
                cur = cur - 1
                Nullable{BraidElement}(braidfromintrep(g, [ir]))
            elseif cur == 1
                ir = cur
                cur = cur + 1
                Nullable{BraidElement}(braidfromintrep(g, [ir]))
            elseif rand() < 0.5
                ir = cur
                cur = cur + 1
                Nullable{BraidElement}(braidfromintrep(g, [ir]))
            else
                ir = -1 * cur
                cur = cur - 1
                Nullable{BraidElement}(braidfromintrep(g, [ir]))
            end
        else
            Nullable{BraidElement}(one(g))
        end
    end
end

"""
Get a sampler based on a crude discretization of the Gaussian (for
experimentation only).
"""
function getgsampler(g::BraidGroup, sprob::Float64)
    ct = 0
    () -> begin
      if rand() < sprob
          Nullable{BraidElement}()
      else
          ir = convert(Int64, max(min(floor(randn() * (g.n / 2)), g.n - 1), -1*g.n + 1))
          if ir == 0
              Nullable{BraidElement}(one(g))
          else
              Nullable{BraidElement}(braidfromintrep(g, [ir]))
          end
      end
    end
end
