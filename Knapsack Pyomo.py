# In[]:
##### Knapsack
import pyomo.environ as pyo

Knapsack_model = pyo.ConcreteModel()

Knapsack_model.ind = pyo.Set(initialize = [i for i in range(10)])
Knapsack_model.x = pyo.Var(Knapsack_model.ind, domain = pyo.Binary)
Values = [10,40,20,50,30,30,10,40,20,20]
Weights = [1,1,2,1,1,2,0.5,3,2,3]
W = 8.5
Knapsack_model.OBJ1 = pyo.Objective(expr = pyo.quicksum(Knapsack_model.x[i] * Values[i] for i in Knapsack_model.ind) , sense = pyo.maximize)
Knapsack_model.Constraint = pyo.Constraint(expr = pyo.quicksum(Knapsack_model.x[i] * Weights[i] for i in Knapsack_model.ind) <= W)


solver = pyo.SolverFactory('cplex')
solver.options['mipgap'] = 0.001                  
result1 = solver.solve(Knapsack_model)
result1.write()
Items = []
for i in Knapsack_model.ind:
    Items.append(pyo.value(Knapsack_model.x[i]))
