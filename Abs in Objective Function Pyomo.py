# In[]: Abs in Objective
import pyomo.environ as pyo
absmodel1 = pyo.ConcreteModel()
absmodel1.x1 = pyo.Var(within=pyo.Reals)
absmodel1.x2 = pyo.Var(within=pyo.Reals) 
absmodel1.x3 = pyo.Var(within=pyo.Reals)  
absmodel1.U1 = pyo.Var(within=pyo.NonNegativeReals)
absmodel1.U2 = pyo.Var(within=pyo.NonNegativeReals)
absmodel1.U3 = pyo.Var(within=pyo.NonNegativeReals)
absmodel1.OBJJ = pyo.Objective(expr = absmodel1.U1 * 2 + absmodel1.U2 * 3 + absmodel1.U3 , sense = pyo.minimize)   
absmodel1.C11 = pyo.Constraint(expr = absmodel1.x1 + absmodel1.x2 * 2 - absmodel1.x3 * 3 <= 8)
absmodel1.C21 = pyo.Constraint(expr = absmodel1.x1 * 2 - absmodel1.x2 + 4 * absmodel1.x3 == 14)
absmodel1.C31 = pyo.Constraint(expr = absmodel1.x1 >= -1 * absmodel1.U1)
absmodel1.C41 = pyo.Constraint(expr = absmodel1.x1 <=  absmodel1.U1)
absmodel1.C51 = pyo.Constraint(expr = absmodel1.x2 >= -1 * absmodel1.U2)
absmodel1.C61 = pyo.Constraint(expr = absmodel1.x2 <=  absmodel1.U2)
absmodel1.C71 = pyo.Constraint(expr = absmodel1.x3 >= -1 * absmodel1.U3)
absmodel1.C81 = pyo.Constraint(expr = absmodel1.x3 <=  absmodel1.U3)
solver = pyo.SolverFactory('cplex')
solver.options['mipgap'] = 0.001                  
result2 = solver.solve(absmodel1) 
result2.write()          
print(result2)
[x1,x2,x3] = [pyo.value(absmodel1.x1),pyo.value(absmodel1.x2),pyo.value(absmodel1.x3)]
print(x1,x2,x3)
print("Optimal Objective:" + str(pyo.value(absmodel1.OBJJ)))
