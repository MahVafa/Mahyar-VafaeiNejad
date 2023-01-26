import numpy as np
import matplotlib.pyplot as plt
import random
# In[] GA Parameters
Maxit = 200
Npop = 600
mu = 0.01
pc = 0.3
nc = int(2 * np.round(pc * Npop/2))
pm = 0.5
nm = int(pm * Npop)
Items = 120
MaxW = 300
M = 1000
BestValues = []
Values = np.zeros((Npop,1))
Iterations = []
Crossovers = np.zeros((nc,Items))
Mutants = np.zeros ((nm,Items))
np.random.seed(seed=1)
Prices = np.random.randint(10,50,(Items))
np.random.seed(seed=1)
w = np.random.randint(1,8,(Items))
np.random.seed(seed=1)
Sol = np.random.randint(0,2,(Items))
# In[] Knapsack Objective Function
def KnapsackValue(S):
    Weight = np.sum(S * w)
    V = max(0,Weight - MaxW)
    if V == 0:
        Feas = True
    else:
        Feas = False
    Z = np.sum(S * Prices) - M * V
    return Z, V, Feas, S
# In[] Crossovers
def SPCO(P1,P2):
    n = np.size(P1)
    cp = random.randint(1,n-1)
    O1 = P1.copy()
    O1[0:cp] = P2[0:cp]
    O2 = P2.copy()
    O2[0:cp] = P1[0:cp]
    return O1,O2
def DPCO(P1,P2):
    n = np.size(P1)
    cp = random.sample(range(1,n-1),2)
    cp1 = np.min(cp)
    cp2 = np.max(cp)
    O1 = P1.copy()
    O1[0:cp1] = P2[0:cp1]
    O1[cp2:] = P2[cp2:]
    O2 = P2.copy()
    O2[0:cp1] = P1[0:cp1]
    O2[cp2:] = P1[cp2:]
    return O1,O2
def UCO(P1,P2):
    n = np.size(P1)
    alpha = np.random.randint(0,2,(1,n))
    O1 = alpha * P1 + (1 - alpha) * P2
    O2 = alpha * P2 + (1 - alpha) * P1
    return O1,O2
def ACO(P1,P2):
    n = np.size(P1)
    alpha = np.random.uniform(0,1,(1,n))
    O1 = alpha * P1 + (1 - alpha) * P2
    O2 = alpha * P2 + (1 - alpha) * P1
    return O1,O2
# In[] Mutation
def Mutation(P):
    n = np.size(P)
    O = P.copy()
    x = int(np.ceil(mu * n))
    x_mu = random.sample(range(0,n),x)
    O[x_mu] = 1 - P[x_mu]
    return O  
# In [] GA Random Operator 
def GA_CrossoverOperator(P1,P2):
    rnd = np.random.uniform(0,1)
    if rnd < 0.33:
        #print('Single-Point Crossover')
        return SPCO(P1,P2)
    elif rnd < 0.65:
        #print('Double-Point Crossover')
        return DPCO(P1,P2)        
    else:
        #print('Uniform Crossover')
        return UCO(P1,P2)        
# In[] GA Main Script
Pop = np.random.randint(0,2,(Npop,Items))
Values = [KnapsackValue(Pop[i])[0] for i in range(np.shape(Pop)[0])]
Sorted_Pop_ind = np.argsort(Values)
Sorted_Pop = Pop[[Sorted_Pop_ind]]
for it in range (1,Maxit+1):    
    for c in range(0,nc):
        P_Index = random.sample(range(0,Npop),2)
        P1 = Pop[np.min(P_Index)]
        P2 = Pop[np.max(P_Index)]
        Crossovers[2*c:] = GA_CrossoverOperator(P1,P2)[0]
        Crossovers[2*c+1:] = GA_CrossoverOperator(P1,P2)[1]
    for m in range(0,nm):
        P_Index = random.sample(range(0,Npop),1)
        P = Pop[P_Index].reshape(Items,)
        Mutants[m:] = Mutation(P)     
    T_Pop = np.unique(np.vstack((Pop,Crossovers,Mutants)),axis=0)
    Values = [KnapsackValue(T_Pop[i])[0] for i in range(np.shape(T_Pop)[0])]
    Sorted_Pop_ind = np.argsort(Values)
    T_Pop = T_Pop[[Sorted_Pop_ind]]
    Pop = T_Pop[-Npop:]
    BestValues.append(KnapsackValue(Pop[-1])[0])
    print("The Best Value of Knapsack IN ITER {} is: {} + Feasibility:{} + Violation:{}, Sol = {}".format(it,KnapsackValue(Pop[-1])[0],KnapsackValue(Pop[-1])[2],KnapsackValue(Pop[-1])[1],KnapsackValue(Pop[-1])[3]))
    Iterations.append(it)
# In[] Plotting
plt.plot(Iterations,BestValues,'g--')
plt.title('Value Changes By Iterations')
plt.xlabel('Iterations')
plt.ylabel('Values')
plt.show()