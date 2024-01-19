# In[]:
#### Supply chain
import pyomo.environ as pyo

SC_model = pyo.ConcreteModel()
SC_model.i = pyo.Set(initialize = ['Abidi','TehranShimi'])
SC_model.j = pyo.Set(initialize = ['Adora','Ferdows'])    
SC_model.k = pyo.Set(initialize = [i for i in range(3)])    

SC_model.xij = pyo.Var(SC_model.i, SC_model.j, domain = pyo.NonNegativeReals)
SC_model.yjk = pyo.Var(SC_model.j,SC_model.k, domain = pyo.NonNegativeReals)

S = {}
S['Abidi'] = 100
S['TehranShimi'] = 50
D = [70,40,40]

Cij = {} 
for i in SC_model.i:
    for j in SC_model.j:
        Cij[i,j] = 0
Cij['Abidi','Adora'] = 10
Cij['Abidi','Ferdows'] = 15
Cij['TehranShimi','Adora'] = 8
Cij['TehranShimi','Ferdows'] = 12

Cjk = {} 
for j in SC_model.j:
    for k in SC_model.k:
        Cjk[j,k] = 0
Cjk['Adora',0] = 15
Cjk['Adora',1] = 20
Cjk['Adora',2] = 10
Cjk['Ferdows',0] = 8
Cjk['Ferdows',1] = 15
Cjk['Ferdows',2] = 16

SC_model.OBJ = pyo.Objective(expr = pyo.quicksum(SC_model.xij[i,j] * Cij[i,j] for (i,j) in SC_model.i*SC_model.j) + pyo.quicksum(SC_model.yjk[j,k] * Cjk[j,k] for (j,k) in SC_model.j*SC_model.k) , sense = pyo.minimize)


def rule_1(SC_model, i):
    return (pyo.quicksum(SC_model.xij[i,j]  for j in SC_model.j) <= S[i])
SC_model.Constraint1=pyo.Constraint(SC_model.i, rule = rule_1)

def rule_2(SC_model, k):
    return (pyo.quicksum(SC_model.yjk[j,k]  for j in SC_model.j) >= D[k])
SC_model.Constraint2=pyo.Constraint(SC_model.k, rule = rule_2)

def rule_3(SC_model, j):
    return (pyo.quicksum(SC_model.yjk[j,k]  for k in SC_model.k) <= pyo.quicksum(SC_model.xij[i,j]  for i in SC_model.i))
SC_model.Constraint3=pyo.Constraint(SC_model.j, rule = rule_3)

solver = pyo.SolverFactory('cplex')
solver.options['mipgap'] = 0.001                  
result2 = solver.solve(SC_model)
result2.write()
print(pyo.value(SC_model.xij['Abidi','Ferdows']))
print(pyo.value(SC_model.xij['Abidi','Adora']))
print(pyo.value(SC_model.xij['TehranShimi','Adora']))    
print(pyo.value(SC_model.xij['TehranShimi','Ferdows']))
print(pyo.value(SC_model.yjk['Ferdows',0]))
print(pyo.value(SC_model.yjk['Ferdows',1]))
print(pyo.value(SC_model.yjk['Ferdows',2]))
print(pyo.value(SC_model.yjk['Adora',0]))   
print(pyo.value(SC_model.yjk['Adora',1])) 
print(pyo.value(SC_model.yjk['Adora',2])) 
