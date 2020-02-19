##flattening a nested set
function unfold(A)
    V = []
    for x in A
        if x === A
            push!(V, x)
        else
            append!(V, unfold(x))
        end
    end
    V
end



function set_cover(universe, subsets)
    """Find a family of subsets that covers the universal set"""
    elements = Set(e for s in subsets for e in s)
    # Check the subsets cover the universe
    if elements != universe
        return None
    end
    covered = Set()

    # Greedily add the subsets with the most uncovered points

    while Set(unfold(covered)) != elements
        subset = filter(x-> length(setdiff(x,Set(unfold(covered)))) == maximum(map(y -> length(setdiff(y,Set(unfold(covered)))), subsets)), subsets)
        push!(covered,subset)

    end
    println("The cell towers needed to construct so as to cover all the neighbourhoods are : ")
    println(" ")
    println(covered)
    return covered #### The
end

universe = Set(range(1, stop=15))
subsets = [Set{Int64}([1, 2]), Set{Int64}([2,3,5]), Set{Int64}([1,7,9,10]), Set{Int64}([4,6,8,9]),
        Set{Int64}([6,7,9,11]),Set{Int64}([5,7,10,12,14]),Set{Int64}([12,13,14,15])]

covered = set_cover(universe, subsets)
