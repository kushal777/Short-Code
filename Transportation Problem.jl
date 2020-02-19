using JuMP, GLPKMathProgInterface
using GLPK

supply_nodes = ["C1";"C2";"C3"]
demand_nodes =["W1" "W2" "W3" "W4"]
s = [75;125;100]
d = [80 65 70 85]

cost = [464	513	654	867;352	416	690	791;995	682	388	685]

s_dict = Dict()

for i in 1:length(supply_nodes)
  s_dict[supply_nodes[i]] = s[i]
end

s_dict
s_dict = Dict(zip(supply_nodes, s))

d_dict = Dict( zip(demand_nodes, d))

c_dict = Dict()
for i in 1:length(supply_nodes)
  for j in 1:length(demand_nodes)
    c_dict[supply_nodes[i], demand_nodes[j]] = cost[i,j]
  end
end


tp= Model(with_optimizer(GLPK.Optimizer))

@variable(tp, x[supply_nodes, demand_nodes] >= 0)
@objective(tp, Min, sum(c_dict[i,j]*x[i,j]
                    for i in supply_nodes, j in demand_nodes))
for i in supply_nodes
  @constraint(tp, sum(x[i,j] for j in demand_nodes) == s_dict[i] )
end
for j in demand_nodes
  @constraint(tp, sum(x[i,j] for i in supply_nodes) == d_dict[j] )
end

print(tp)
optimize!(tp)

x_star = JuMP.value.(x)
println("The optimal solution matrix is :", x_star)
print("The optimal objective value is :", objective_value(tp))
