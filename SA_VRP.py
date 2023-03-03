import random
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import math
class VRP():
   def __init__(self,Ite1,Ite2,T,Alpha,V,D):
       self.Ite1=Ite1
       self.Ite2=Ite2
       self.T=T
       self.Alpha=Alpha
       self.V=V
       self.D=D
       self.Distance2=np.zeros((self.D,self.D))
       self.Distance1=np.zeros((1,self.D))
       np.random.seed(seed=1)
       self.Demands = np.random.randint(50,150,self.D)
       self.Capacity = np.random.randint(600,800,self.V)
       self.usedcap = np.zeros(self.V,)
       self.xd=np.random.randint(0,900,self.D)
       self.yd=np.random.randint(0,1200,self.D)
       self.x0=450
       self.y0=600
       self.Costs=[]
       self.BestSols=[]
       self.Iterations=[]
       self.MinCosts=[]
       for i in range(self.D):
           self.Distance1[0,i]=math.sqrt((self.xd[i]-self.x0)**2+(self.yd[i]-self.y0)**2)
           for j in range(self.D):
               if i == j:
                   self.Distance2[i,j] = 0
               else:
                   self.Distance2[i,j] = math.sqrt((self.xd[i]-self.xd[j])**2+(self.yd[i]-self.yd[j])**2)
                   self.Distance2[j,i]=self.Distance2[i,j]
       np.random.seed(seed=1)
       self.t1=np.random.randint(50,100)
       self.t2=np.random.randint(120,170)
       self.S=60
       self.n=self.V+self.D-1
       self.Feas=True
       self.M=10000 
   def RandomSol(self):
       self.randsol = np.random.permutation(self.n) + 1
   def Insertion(self,arr):
       r = random.sample(range(np.size(arr)),2)
       r1 = np.min(r)
       r2 = np.max(r)
       result = arr.copy()
       result = np.insert(result,0,arr[r2])
       result = np.append(result,arr[r1])
       result = np.delete(result,r1+1)
       result = np.delete(result,r2)
       return result
   def Reversion(self,arr):
       r = random.sample(range(np.size(arr)),2)
       r1 = np.min(r)
       r2 = np.max(r)
       result = arr.copy()
       sliced = arr[r1:r2+1]
       result[r1:r2+1] = sliced[::-1]
       return result
   def Swap(self,arr):
       r = random.sample(range(np.size(arr)),2)
       r1 = np.min(r)
       r2 = np.max(r)
       result = arr.copy()
       Temp = 0
       Temp = result[r1]
       result[r1] = result[r2]
       result[r2] = Temp
       return result
   def Rnd_Sel_Con(self,arr):
       rand = np.random.rand()
       if rand < 0.33:
           return self.Reversion(arr)
       elif rand < 0.66 :
           return self.Insertion(arr)
       else:
           return self.Swap(arr)
   def SA_VRP_Cost(self,Solution):
       self.Viol1 = 0
       self.Viol2 = np.zeros(self.D)
       self.Viol = 0
       self.L = [[] for i in range(self.V)]
       self.Dist=[]
       self.Sep_ind = []
       self.Sep_arr = Solution[Solution>self.D]
       self.Array_Range = np.arange(0,self.n)
       self.Sep_ind = self.Array_Range[Solution>self.D]
       for i in range(1,self.V):
           if i == 1:
               self.L[i-1]=Solution[:self.Sep_ind[i-1]]            
               self.L[-1]=Solution[self.Sep_ind[-1]+1:]
           elif (i > 1 and i < self.V):
               self.L[i-1]=Solution[self.Sep_ind[i-2]+1:self.Sep_ind[i-1]]
       self.Tra_Dis = np.zeros(self.V,)
       for l in range(np.shape(self.L)[0]):
           if np.size(self.L[l]) == 1:
               self.Tra_Dis[l] = 2 * self.Distance1[0,self.L[l][0]-1]
           elif np.size(self.L[l]) == 0:
               self.Tra_Dis[l] = 0
           else:
               self.Tra_Dis[l] = self.Distance1[0,self.L[l][0]-1] + self.Distance1[0,self.L[l][-1]-1]
               for d in range(np.size(self.L[l])-1):
                   self.Tra_Dis[l] += self.Distance2[self.L[l][d]-1,self.L[l][d+1]-1]
       self.Z1 = np.sum(self.Tra_Dis)
       self.Z2 = np.max(self.Tra_Dis)
       # for l in range(vrp.V):
       #       self.usedcap[l] = np.sum([vrp.Demands[vrp.L[l]-1] for k in range(np.size(vrp.L[l]))])
       #       if self.usedcap[l] > vrp.Capacity[l]:
       #             self.Viol1 += self.usedcap[l] - vrp.Capacity[l]
       #             self.Feas = False
       self.Z = 1*self.Z1 +   4*self.Z2 + self.Viol1 * self.M
       return self.Z ,self.Feas             
vrp = VRP(100,900,200,0.95,3,20) 
vrp.RandomSol()         
Sol = vrp.randsol
BestCost = vrp.SA_VRP_Cost(Sol)[0]
vrp.Costs.append(BestCost)
vrp.BestSols.append(Sol)
for k in range(vrp.Ite1):
     vrp.Iterations.append(k + 1)
     for i in range(vrp.Ite2):
         NewSol = vrp.Rnd_Sel_Con(Sol)
         NewSol_Cost = vrp.SA_VRP_Cost(NewSol)[0]
         vrp.Costs.append(NewSol_Cost)
         if NewSol_Cost <= BestCost:
             BestCost = NewSol_Cost 
             vrp.Feas = vrp.SA_VRP_Cost(NewSol)[1]
#             V = SA_Cost(NewSol,V,D)[6]
             Sol = NewSol
         else:
             rn = np.random.rand()
             Delta = NewSol_Cost - BestCost
             if rn <= np.exp((-1*Delta)/vrp.T):
                 BestCost = NewSol_Cost
                 vrp.Feas = vrp.SA_VRP_Cost(NewSol)[1]
#                 V = SA_Cost(NewSol,V,D)[6]
                 Sol = NewSol
     print("THE BEST Cost IN ITER {} and Temp {} is: {}--Feasibility:{} ".format(k+1,vrp.T,BestCost,vrp.Feas))
     vrp.BestSols.append(Sol)
     vrp.MinCosts.append(np.min(vrp.Costs))
     vrp.T = vrp.T * vrp.Alpha
plt.plot(vrp.Iterations,vrp.MinCosts,'g--')
plt.title('Cost Changes By Iterations')
plt.xlabel('Iterations')
plt.ylabel('Costs')
plt.show()
plt.figure()
plt.plot(vrp.xd,vrp.yd,'ro')
plt.plot(vrp.x0,vrp.y0,'y^',markersize=22)
colors = ['c','g','b','r','g','k','m','y']
for l in range(np.shape(vrp.L)[0]):
    for e in range(np.shape(vrp.L[l])[0]):
        plt.text(vrp.xd[vrp.L[l][e]-1],vrp.yd[vrp.L[l][e]-1],"{}".format(vrp.L[l][e]),fontsize=18,fontweight='bold',color='black')  
for l in range(np.shape(vrp.L)[0]):
    if np.size(vrp.L[l]) != 0:
        plt.plot([vrp.xd[vrp.L[l][0]-1],vrp.x0],[vrp.yd[vrp.L[l][0]-1],vrp.y0],colors[l],linestyle='--',markersize=9)
        plt.plot([vrp.xd[vrp.L[l][-1]-1],vrp.x0],[vrp.yd[vrp.L[l][-1]-1],vrp.y0],colors[l],linestyle='--',markersize=9)
        for c in range(np.size(vrp.L[l])-1):
            plt.plot([vrp.xd[vrp.L[l][c]-1],vrp.xd[vrp.L[l][c+1]-1]],[vrp.yd[vrp.L[l][c]-1],vrp.yd[vrp.L[l][c+1]-1]],colors[l],linestyle='--',markersize=9)
plt.title('VRP Tours')
plt.xlabel('X Points')
plt.ylabel('Y Points')
plt.show()

