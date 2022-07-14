# -*- coding: utf-8 -*-
"""
Created on Sun Jun 26 19:19:35 2022

@author: mahkam
"""

def Fibo(n):
    fibo = [0,1]
    i = 1
    if n == 1:
        return fibo
    else:
        while i < n:
            fibo.append(fibo[i]+ fibo[i-1])
            i += 1
        return fibo
    
    
   
       