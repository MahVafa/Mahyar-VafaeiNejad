import random
import numpy as np
import matplotlib.pyplot as plt
# In[] Initial Parameters Of SA
Ite1 = 100
Ite2 = 900
T = 1000
Alpha = 0.9
BestCost = 0
Costs = []
Iterations = []
MinCosts = []
BestSols = []
ST = 2
m = 16
j = 100
P = np.random.randint(1,20,size=j)
D = np.random.randint(80,160,size=j)
n = m + j - 1
FM = 0
M = 1000
# In[] Creating Random Solution
def RandomSol(n):
    randsol = np.random.permutation(n) + 1
    return randsol

# In[] Calculating Makespan
def SA_Cost(randsol):
    Make_Span = np.zeros(m)
    BT = np.zeros(j)
    FT = np.zeros(j)
    V = np.zeros(j)
    L = [[] for i in range(m)]
    Sep_ind = []
    Sep_arr = randsol[randsol>j]
    Array_Range = np.arange(0,n)
    Sep_ind = Array_Range[randsol>j]
    #Sep_ind=(np.where(randsol>j))
    for i in range(1,m):
        if i == 1:
            L[i-1]=randsol[:Sep_ind[i-1]]            
            L[-1]=randsol[Sep_ind[-1]+1:]
        elif (i > 1 and i < m):
            L[i-1]=randsol[Sep_ind[i-2]+1:Sep_ind[i-1]]
   
    for l in range(np.shape(L)[0]):
        ES = 0
        for k in range(np.size(L[l])):
            for v in range(j):
                if L[l][k] == v:
                    BT[v-1] = ES
                    FT[v-1] = BT[v-1] + P[L[l][k]-1]
                    ES = FT[v-1] + ST
                   
        Make_Span[l] = ES - ST
        
    for i in range(j):
        if FT[i] > D[i]:
            V[i] = FT[i]- D[i]
     
        
    Z = np.max(Make_Span) * (1 + M * np.sum(V))
    return L ,FT, BT, Z, Make_Span
   
   
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
    if n > 1:
        return Swap(arr)
    elif (n < 0) :
        return Insertion(arr)
    else:
        return Reversion(arr)    
# In[]  SA Algorithm
Sol = RandomSol(n)
BestCost = SA_Cost(Sol)[3]
Costs.append(BestCost)
BestSols.append(Sol)
for k in range(Ite1):
    Iterations.append(k + 1)
    for i in range(Ite2):
        NewSol = Rnd_Sel_Con(Sol)
        NewSol_Cost = SA_Cost(NewSol)[3]
        Costs.append(NewSol_Cost)
        if NewSol_Cost <= BestCost:
            BestCost = NewSol_Cost  
            Sol = NewSol
        else:
            rn = np.random.rand()
            Delta = NewSol_Cost - BestCost
            if rn <= np.exp((-1*Delta)/T):
                BestCost = NewSol_Cost
                Sol = NewSol
    print("THE BEST Cost IN ITER {} and Temp {} is: {}".format(k+1,T,BestCost))
    BestSols.append(Sol)
    MinCosts.append(np.min(Costs))
    T = T * Alpha
Jo_Ma = SA_Cost(BestSols[-1])[0]
FT = SA_Cost(BestSols[-1])[1]
BT = SA_Cost(BestSols[-1])[2]
Z = SA_Cost(BestSols[-1])[3]
# In[] Plotting Cost Changes
# plt.plot(Iterations,Costs,'g--')
# plt.title('Cost Changes By Iterations')
# plt.xlabel('Iterations')
# plt.ylabel('Costs')
# plt.show()
# In[] Plotting the Jobs:
h = 0.2
for g in range(len(Jo_Ma)):
    for k in range(len(Jo_Ma[g])):
        plt.fill((BT[Jo_Ma[g][k]-1],BT[Jo_Ma[g][k]-1],FT[Jo_Ma[g][k]-1],FT[Jo_Ma[g][k]-1]),(g+1-h,g+1+h,g+1+h,g+1-h),[random.randint(0,20),random.randint(200,255),random.randint(100,120)])
        plt.text(((BT[Jo_Ma[g][k]-1]+FT[Jo_Ma[g][k]-1])/2),(g+1),"{}".format(Jo_Ma[g][k]),fontsize=16,ha='center',va='center',color='black')
plt.axvline(x=Z,ymin=0,ymax=m,linestyle='dashed',color='g')
plt.text(Z*1.01,(m/2),'Tmax',color='g')
plt.text(Z,0,'{}'.format(Z),fontsize=15,color='r')
plt.xlim([0,100])
plt.ylim([0,m+1])
plt.title('Jobs Sequence')
plt.xlabel('Time (minute)')
plt.ylabel('Parallel Machines')
plt.show()