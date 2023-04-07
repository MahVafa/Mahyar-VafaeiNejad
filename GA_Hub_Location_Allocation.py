import numpy as np
import matplotlib.pyplot as plt
import random
import math
# In[] GA Parameters
Maxit = 200
Npop = 100
mu = 1.0
pc = 0.3
nc = int(2 * np.round(pc * Npop/2))
pm1 = 0.5
nm1 = int(pm1 * Npop)
pm2 = 0.8
nm2 = int(pm2 * Npop)
M = 1000
Cities = int(input("Please enter the number of cities: "))
np.random.seed(seed = 1)
xs = np.random.randint(0,900,Cities)
np.random.seed(seed = 1)
ys = np.random.randint(0,1200,Cities)
Hubs = 3
alpha = 0.75
np.random.seed(seed = 1)
BestValues = []
Values = np.zeros((Npop,1))
Iterations = []
Crossovers = np.zeros((nc,Cities,Cities))
Mutants1 = np.zeros ((nm1,Cities,Cities))
Mutants2 = np.zeros ((nm2,Cities,Cities))
np.random.seed(seed = 1)
F = np.random.randint(150000,350000,Cities)
D = np.random.randint(1,100,(Cities,Cities))
# In[] Create Random Solution
def Randsol(n):
    Sol1 = np.random.uniform(0,1,(n,n))
    return Sol1
# In[] Distance Matrix
distance = np.zeros((Cities,Cities))
for i in range(np.shape(distance)[0]):
    for j in range(np.shape(distance)[1]):
        distance[i,j] = math.sqrt((xs[i]-xs[j])**2 + (ys[i]-ys[j])**2)
# In[] HubCost Evaluation
def Hub_Cost(S):
    H = []
    h = tuple()
    Z_M = np.zeros((Cities,Cities))
    diag = np.diag(S)
    Bests = np.argsort(diag)[-Hubs:][::-1]
    S2 = S.copy()
    c = np.count_nonzero(diag > 0.5) 
    for i in range(np.shape(S)[0]):
        if c >= Hubs:
            for j in range(np.shape(Bests)[0]):
                if i == Bests[j] and diag[i] > 0.5:
                    S2[:,i] = 0
                    S2[i,i] = 1
        elif c < Hubs and c > 1:
            if diag[i] > 0.5:
                S2[:,i] = 0
                S2[i,i] = 1            
        elif c == 0 or c == 1:
            m = np.argmax(diag)
            S2[m,m] = 1
        if S2[i,i] < 0.5 or i not in Bests:
            S2[i,i] = 0
            S2[i,:] = 0           
    H = np.argmax(S2,axis=0) 
    h_final = h + np.where(np.diag(S2) == 1)
    H_Estab = np.diag(S2)
    for i in range(np.shape(S)[0]):
        for j in range(np.shape(S)[0]):
            if i != j:
                Z_M[i,j] = D[i,j] * (distance[i,H[i]] + alpha * distance[H[i],H[j]] + distance[H[j],j])     
            else:
                Z_M[i,j] = 0
    Z1 = np.sum(Z_M)
    Z2 = np.sum(F * H_Estab)
    Z = np.round(0 * Z1 + 1 * Z2 + 10*np.count_nonzero(np.diag(S) > 0.5))
    return    Z1,Z2, Z, S2, H, h_final, H_Estab , Z_M                        
# In[] Crossovers
def Swaprows(P):
    n = np.shape(P)[0]
    r = random.sample(range(n),2)
    cp1= np.min(r)
    cp2= np.max(r)
    O =np.matrix(P.copy())
    O[[cp1,cp2],:] = O[[cp2,cp1],:]
    return O,P,cp1,cp2
def Swapcolumns(P):
    n = np.shape(P)[0]
    r = random.sample(range(n),2)
    cp1= np.min(r)
    cp2= np.max(r)
    O =np.matrix(P.copy())
    O[:,[cp1,cp2]] = O[:,[cp2,cp1]]
    return O,P,cp1,cp2
def Mut_diag(P):
    n = np.shape(P)[0]
    S = random.sample(range(n),np.random.randint(1,3))
    O = P.copy()
    for k in range(np.shape(S)[0]):
        O[S[k],S[k]] =  O[S[k],S[k]] + np.random.randn() * 0.2
        if O[S[k],S[k]] < 0:
            O[S[k],S[k]] = 0
        else:
            O[S[k],S[k]] = min(O[S[k],S[k]],1)
    return O
# In[] Mutation
def Mutation(P):
    O = P.copy()
    n = np.random.randint(1,max(int(np.ceil(np.shape(P)[0] * np.shape(P)[0] * mu)),5))
    for i in range(n):
        S = [random.randint(0,Cities-1) for i in range(2)]
        O[S[0],S[1]] = O[S[0],S[1]] + np.random.normal() * 0.08       
        if O[S[0],S[1]] < 0:
            O[S[0],S[1]] = 0
        else:
            O[S[0],S[1]] = min(O[S[0],S[1]],1)       
    return O  
# In [] GA Random Operator 
def Hub_Operator(P):
    rnd = np.random.uniform(0,1)
    if rnd < 0.25:
        return Swaprows(P)
    elif rnd < 0.5:
        return Swapcolumns(P)        
    else:
        return Mutation(P)        
# In[] GA Main Script
Pop = np.array([Randsol(Cities) for i in range(Npop)])
Values = [Hub_Cost(Pop[i])[2] for i in range(np.shape(Pop)[0])]
Sorted_Pop_ind = np.argsort(Values)
Sorted_Pop = Pop[[Sorted_Pop_ind]]
for it in range (1,Maxit+1):
    if it%100 ==0:
        mu= mu/10    
    for c in range(nc):
        P_Index = random.sample(range(0,Npop),1)
        P = Pop[P_Index].reshape([Cities,Cities])
        if np.mod(c,2) == 0:
            Crossovers[c][:] = Swaprows(P)[0]
        else:
            Crossovers[c][:] = Swapcolumns(P)[0]       
    for m in range(0,nm1):
        P_Index = random.sample(range(0,Npop),1)
        P = Pop[P_Index].reshape([Cities,Cities])
        Mutants1[m:] = Mutation(P)
    for m in range(0,nm2):
        P_Index = random.sample(range(0,Npop),1)
        P = Pop[P_Index].reshape([Cities,Cities])
        Mutants2[m:] = Mut_diag(P)
    T_Pop = np.unique(np.vstack((Pop,Crossovers,Mutants1,Mutants2)),axis=0)
    Values = np.array([Hub_Cost(T_Pop[i])[2] for i in range(np.shape(T_Pop)[0])])
    Sorted_Pop_ind = np.argsort(Values)
    T_Pop = T_Pop[[Sorted_Pop_ind]]
    Pop = T_Pop[0:Npop]
    BestValues.append(Hub_Cost(Pop[0])[2])
    print("The Best Cost of Hub IN ITER {} is: {} ".format(it,Hub_Cost(Pop[0])[2]))
    Iterations.append(it)
# In[] Extracting the best solution & Plotting
Bestsol = Hub_Cost(Pop[0])[4]
HUBS = Hub_Cost(Pop[0])[6]
fig = plt.figure()
ax1 = fig.add_subplot(1, 2, 1)
ax2 = fig.add_subplot(1, 2, 2)
ax1.plot(Iterations,BestValues,'g--')
ax1.set_title('Cost Changes By Iterations')
ax1.set_xlabel('Iterations')
ax1.set_ylabel('Cost')
for i in range(np.shape(Bestsol)[0]):
    if HUBS[i] == 1:
        ax2.plot(xs[i],ys[i],'y^',markersize=18)
    else:
        ax2.plot(xs[i],ys[i],'ro')
    ax2.plot([xs[i],xs[(Bestsol[i])]],[ys[i],ys[(Bestsol[i])]],'black',linestyle='--')
ax2.set_title('P_Hub Allocation')
ax2.set_xlabel('Xs')
ax2.set_ylabel('Ys')
   


