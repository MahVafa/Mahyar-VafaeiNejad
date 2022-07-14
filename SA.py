import random
import numpy as np
import matplotlib.pyplot as plt
# In[] Initial Parameters Of SA
Ite1 = 700
Ite2 = 2000
T = 300
Alpha = 0.9
BestCost = 0
Costs = []
Iterations = []
MinCosts = []
BestSols = []
n = int(input("Please Enter The Number Of Cities: "))
# In[] Creating Random Solution
def RandomSol(n):
    randsol = np.random.permutation(n) + 1 
    return randsol
# In[] Distance Matrix
np.random.seed(seed = 1)
distance = np.zeros((n,n))
for i in range(n):
    for j in range(n):
        if i == j:
            distance[i,j] = 0
        else:
            distance[i,j] = np.random.randint(50,700)
            distance [j,i] = distance [i,j]
# In[] Cost Function
def SA_Cost(randsol):
    l = 0
    cost = 0
    while l < np.size(randsol) - 1:
            cost += distance[randsol[l] - 1  , randsol[l + 1] - 1]
            l += 1
    return cost  
# In[] Basic Functions for generating solutions  
def Insertion(arr):
    r = random.sample(range(np.size(arr)),2)
    r1 = np.min(r)
    r2 = np.max(r)
    result = arr
    result = np.insert(result,0,arr[r2])
    result = np.append(result,arr[r1])
    result = np.delete(result,r1+1)
    result = np.delete(result,r2)
    return result
def Reversion(arr):
    r = random.sample(range(np.size(arr)),2)
    r1 = np.min(r)
    r2 = np.max(r)
    result = arr.copy()
    sliced = arr[r1:r2+1]
    result[r1:r2+1] = sliced[::-1]
    return result
def Swap(arr):
    r = random.sample(range(np.size(arr)),2)
    r1 = np.min(r)
    r2 = np.max(r)
    result = arr
    Temp = 0
    Temp = result[r1]
    result[r1] = result[r2]
    result[r2] = Temp
    return result
def Rnd_Sel_Con(arr):
    n = np.random.uniform(0,1)
    if n <= 0.1:
        return Swap(arr)
    elif (n > 0.1) & (n <= 0.35):
        return Insertion(arr)
    else:
        return Reversion(arr)     
# In[]  SA Algorithm
Sol = RandomSol(n)
Sol_Cost = SA_Cost(Sol)
BestCost = Sol_Cost
Costs.append(BestCost)
BestSols.append(Sol)
for k in range(Ite1):
    Iterations.append(k + 1)
    for i in range(Ite2):
        NewSol = Rnd_Sel_Con(Sol)
        NewSol_Cost = SA_Cost(NewSol)
        Costs.append(NewSol_Cost)
        if NewSol_Cost <= BestCost:
            BestCost = NewSol_Cost  
            Sol = NewSol
        else:
            rn = np.random.rand()
            Delta = NewSol_Cost - BestCost
            if rn <= np.exp((-1*Delta)/T):
                NewSol_Cost = SA_Cost(NewSol)
                BestCost = NewSol_Cost 
                Sol = NewSol
    BestSols.append(Sol)
    MinCosts.append(np.min(Costs))
    T = T * Alpha
# In[] Plotting Cost Changes
plt.plot(Iterations,MinCosts,'g--')
plt.title('Cost Changes By Iterations')
plt.xlabel('Iterations')
plt.ylabel('Costs')
plt.show()
