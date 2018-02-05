# Braids.jl

A Julia library for working with [braid groups](https://en.wikipedia.org/wiki/Braid_group).

### Features

- Basic operations on braids (composition, equality, inversion, generators)
- [Unreduced Burau representation](https://en.wikipedia.org/wiki/Burau_representation) of braids into a matrix space over <img src="https://github.com/jwvictor/Braids.jl/raw/master/resources/polyring.png" width="75px" style="margin: 0" /> 
- [Dehornoy reduction](https://dehornoy.users.lmno.cnrs.fr/Papers/Dfo.pdf) of braids, mainly used in the implementation of the equality operation (the Dehornoy always reduces the trivial braid to the identity)

### Motivation

The motivation for building `Braids.jl` is to enable research into braid-based cryptography using the Julia language. There are a wide variety of outstanding questions in braid algorithms that have important applications in post-quantum cryptography. Furthermore, many of these problems require running algorithms requiring massive compute resources, and the Julia implementation makes it easy to build distributed implementations of complex braid algorithms. 

### Related projects

The Burau representation uses [Nemo](http://nemocas.org/) to manipulate polynomials. A field of fractions is used in place of the inverse element (Nemo doesn't yet support negative exponents).



[![Build Status](https://travis-ci.org/jwvictor/Braids.jl.svg?branch=master)](https://travis-ci.org/jwvictor/Braids.jl) [![Coverage Status](https://coveralls.io/repos/jwvictor/Braids.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jwvictor/Braids.jl?branch=master) [![codecov.io](http://codecov.io/github/jwvictor/Braids.jl/coverage.svg?branch=master)](http://codecov.io/github/jwvictor/Braids.jl?branch=master)
