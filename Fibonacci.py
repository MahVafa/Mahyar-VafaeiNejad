
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
    
    
   
       
