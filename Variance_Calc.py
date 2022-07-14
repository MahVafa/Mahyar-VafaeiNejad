# -*- coding: utf-8 -*-
"""
Created on Sat Jul  2 19:36:11 2022


import numpy as np
# In[]: Generating Data
x =[1,2,3,4,5,9,20]
# In[]: Calculating Variance and Presenting it
M = np.mean(x)
c = 0
Sum = 0
Var = 0
while (c < len(x)):
    Sum += (x[c] - M) ** 2 
    c += 1
Var = Sum/((len(x)) ** 2)
print (Var)
