# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt
import random
import math
# In[] GA Parameters
Maxit = 25
Npop = 900
mu = 0.01
pc = 0.3
nc = int(2 * np.round(pc * Npop/2))
pm = 0.5
nm = int(pm * Npop)
M = 1000
Cities = int(input("Please Enter the number of cities: "))
np.random.seed(seed = 1)
xs = np.random.randint(0,900,Cities)
ys = np.random.randint(0,1200,Cities)
Ser = 20
np.random.seed(seed = 1)
xh = np.random.randint(0,900,Ser)
yh = np.random.randint(0,1200,Ser)
BestValues = []
Values = np.zeros((Npop,1))
Iterations = []
Crossovers = np.zeros((nc,Ser))
Mutants = np.zeros ((nm,Ser))
F = np.random.randint(150000,350000,Ser)
D = np.random.randint(50,100,(Cities,1))
# In[] Random Solution
Sol = np.random.randint(0,2,(Ser))
# In[] Distance Matrix
distance = np.zeros((Cities,Ser))
d = np.zeros((Cities,2))
# In[] Hub Objective Function
def Hub_Cost(S):
    for i in range(Cities):
       for j in range(np.size(S)):
           if S[j] == 1:
              distance[i,j] = math.dist([xs[i],ys[i]],[xh[j],yh[j]])
           else:
              distance[i,j] = np.inf
       d[i,0] = np.min(distance[i,:])
       d[i,1] = np.argmin(distance[i,:])
    if np.sum(S) == 0:
      Z1 = np.inf
      Z2 = np.inf
      Z =  np.inf
    else:
      Z1 = np.round(np.sum(F * S),0)
      Z2 = np.round(np.sum(D.T * d[:,0]),0)
      Z = np.round(4 * Z1 + 0 * Z2)  
    return Z, Z1, Z2
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
Pop = np.random.randint(0,2,(Npop,Ser))
Values = [Hub_Cost(Pop[i])[0] for i in range(np.shape(Pop)[0])]
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
        P = Pop[P_Index].reshape(Ser,)
        Mutants[m:] = Mutation(P)     
    T_Pop = np.unique(np.vstack((Pop,Crossovers,Mutants)),axis=0)
    Values = [Hub_Cost(T_Pop[i])[0] for i in range(np.shape(T_Pop)[0])]
    Sorted_Pop_ind = np.argsort(Values)
    T_Pop = T_Pop[[Sorted_Pop_ind]]
    Pop = T_Pop[0:Npop]
    BestValues.append(Hub_Cost(Pop[0])[0])
    print("The Best Cost of Hub IN ITER {} is: {} ".format(it,Hub_Cost(Pop[0])[0]))
    Iterations.append(it)
# In[] Extracting the best solution & Plotting
Bestsol = T_Pop [0]
plt.plot(Iterations,BestValues,'g--')
plt.title('Cost Changes By Iterations')
plt.xlabel('Iterations')
plt.ylabel('Cost')
plt.show()
plt.figure()
plt.plot(xs,ys,'ro')
plt.plot(xh,yh,'y^',markersize=18)
for j in range(np.size(Bestsol)):
    for i in range(Cities):
        plt.plot([xs[i],xh[int(d[i,1])]],[ys[i],yh[int(d[i,1])]],'black',linestyle='--')
   
