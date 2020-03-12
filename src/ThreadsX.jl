baremodule ThreadsX

function map end

function mapreduce end
function reduce end

# Functions derived from `reduce`
function sum end
function prod end
function count end
function maximum end
function minimum end

# Functions implemented directly in terms of transducers
function any end
function all end
function findfirst end
function findlast end
function findall end
# function findmax end
# function findmin end
# function argmax end
# function argmin end
function extrema end
function unique end
function Set end

function foreach end
function map! end

function sort end
function sort! end

module Implementations
using ArgCheck: @argcheck, @check
using BangBang: SingletonVector, append!!, push!!, union!!
using Base: Ordering, add_sum, mapreduce_empty, mul_prod, reduce_empty
using ConstructionBase: setproperties
using InitialValues: Init, asmonoid
using Referenceables: referenceable
using Setfield: @set
using Transducers:
    Cat,
    Empty,
    Filter,
    Map,
    MapSplat,
    OnInit,
    ReduceIf,
    Transducers,
    eduction,
    induction,
    reduced,
    right,
    tcollect,
    tcopy
using ..ThreadsX

@static if VERSION >= v"1.3-alpha"
    using Base.Threads: @spawn
else
    # Mock `@spawn` using `@async`:
    @eval const $(Symbol("@spawn")) = $(Symbol("@async"))
end

# Use README as the docstring of the module:
@doc let path = joinpath(dirname(@__DIR__), "README.md")
    include_dependency(path)
    read(path, String)
end ThreadsX

include("utils.jl")
include("basesizes.jl")
include("reduce.jl")
include("map.jl")
include("mergesort.jl")
include("quicksort.jl")
include("countingsort.jl")
end  # module Implementations

Implementations.@doc (Implementations.@doc Implementations.ParallelMergeSortAlg) ->
const MergeSort = Implementations.ParallelMergeSortAlg()

const QuickSort = Implementations.ParallelQuickSortAlg()
const StableQuickSort =
    Implementations.ParallelQuickSortAlg(smallsort = MergeSort.smallsort)

end # baremodule ThreadX