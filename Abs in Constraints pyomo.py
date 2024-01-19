# In[]: Abs in Constaraint
import pyomo.environ as pyo
absmodel = pyo.ConcreteModel()
absmodel.x1 = pyo.Var(within=pyo.NonNegativeReals)
absmodel.x2 = pyo.Var(within=pyo.NonNegativeReals)   
absmodel.OBJ = pyo.Objective(expr = absmodel.x1 ** 2 - 3 * absmodel.x2 , sense = pyo.minimize)
absmodel.C1 = pyo.Constraint(expr = absmodel.x1 - absmodel.x2 <= 2)
absmodel.C2 = pyo.Constraint(expr = absmodel.x1 - absmodel.x2 >= -2)
solver = pyo.SolverFactory('cplex')
solver.options['mipgap'] = 0.1                    
result = solver.solve(absmodel,tee=True)
result.write()
print(result)
[x1,x2] = [pyo.value(absmodel.x1),pyo.value(absmodel.x2)]
print(x1,x2)
