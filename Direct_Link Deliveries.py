# -*- coding: utf-8 -*-
"""
Created on Sat May 21 20:32:40 2022


"""

import pandas as pd
import numpy as np
import folium
Targets = [90863,126566,109775,117892,108503,124414,132493,119128,136836,147203,168388,187000]
Sheets = ['فروردین','اردیبهشت','خرداد','تیر','مرداد','شهریور','مهر','آبان','آذر','دی','بهمن','اسفند']
df = pd.read_excel('C:\\Users\\mahkam\\Desktop\\پروژه فرصت های ارسال مستقیم در شبکه تیپاکس\\Each_Node_Pickup.xlsx',sheet_name=Sheets[11])
                                                                                                                                     
def Est_Orig_To_Dest(df,L):

# In[]: Rudimentary Calculations    
    df_arr = np.array(df.iloc[2:,3:],dtype=float)
    df_arr = df_arr * ((L*0.8)/np.sum(df_arr))
    Uni_NodeMehvar =np.unique(np.array(df.iloc[2:,1:2]))
    Uni_Ostan = np.unique(df.iloc[2:,0:1])
    NodeMehvar =np.array(df.iloc[2:,1:2])
    Ostan = np.array(df.iloc[2:,0:1])
    Est_NodeMehvar = np.zeros([np.shape(Uni_NodeMehvar)[0],np.shape(Uni_NodeMehvar)[0]])
    Est_Ostan = np.zeros([np.shape(Uni_Ostan)[0],np.shape(Uni_Ostan)[0]])
    
# In[]: Node_To_Node Estimation 
    Direct_Node_Links = []   
    for i in range(np.shape(Uni_NodeMehvar)[0]):
        for j in range(np.shape(Uni_NodeMehvar)[0]):
            Row = np.reshape(NodeMehvar == Uni_NodeMehvar[i],newshape=[382,])
            Temp = df_arr[Row,:]
            Column = np.reshape(NodeMehvar == Uni_NodeMehvar[j],newshape=[382,])
            Est_NodeMehvar[i,j] = np.sum(Temp[:,Column])
    Est_NodeMehvar += np.transpose(Est_NodeMehvar)
    for k in range(np.shape(Est_NodeMehvar)[0]):
        for l in range(np.shape(Est_NodeMehvar)[0]):
            if k >= l:
                Est_NodeMehvar[k,l] = 0
    Est_NodeMehvar = Est_NodeMehvar * ((L*0.8)/(np.sum(Est_NodeMehvar)))
    for k in range(np.shape(Est_NodeMehvar)[0]):
        for l in range(np.shape(Est_NodeMehvar)[0]):            
            if Est_NodeMehvar[k,l] >= 330:
                if Uni_NodeMehvar[k] != 'تهران' and Uni_NodeMehvar[l] != 'تهران':
                    Direct_Node_Links.append(Uni_NodeMehvar[k]+'->'+Uni_NodeMehvar[l]+ ' '+ str(np.round(Est_NodeMehvar[k,l])))             
# In[]: Ostan_To_Ostan Estimation  
    Direct_Ostan_Links = [];           
    for i in range(np.shape(Uni_Ostan)[0]):
        for j in range(np.shape(Uni_Ostan)[0]):
            Row = np.reshape(Ostan == Uni_Ostan[i],newshape=[382,])
            Temp = df_arr[Row,:]
            Column = np.reshape(Ostan == Uni_Ostan[j],newshape=[382,])
            Est_Ostan[i,j] = np.sum(Temp[:,Column])
    Est_Ostan += np.transpose(Est_Ostan)
    for k in range(np.shape(Est_Ostan)[0]):
        for l in range(np.shape(Est_Ostan)[0]):
            if k >= l:
                Est_Ostan[k,l] = 0
    Est_Ostan = Est_Ostan * ((L*0.8)/(np.sum(Est_Ostan)))
    for k in range(np.shape(Est_Ostan)[0]):
        for l in range(np.shape(Est_Ostan)[0]):            
            if Est_Ostan[k,l] >= 350:
                if Uni_Ostan[k] != 'تهران' and Uni_Ostan[l] != 'تهران':
                    Direct_Ostan_Links.append(Uni_Ostan[k]+'->'+Uni_Ostan[l]+ ' '+ str(np.round(Est_Ostan[k,l])))
    return Est_NodeMehvar,Est_Ostan,Direct_Node_Links,Direct_Ostan_Links



# In[]: Running-Function
# Months_Lists = ['Far','Ord','Khor','Tir','Mor','Shah','Mehr','Aban','Azar','Dey','Bah','Esf']
# Estimated_Arr_Monthly = []
# for m in range(len(Months_Lists)):
#     Temp_Dict = dict()
#     Temp_Dict[Months_Lists[m] + '_'+ "Node_Mehvar"],Temp_Dict[Months_Lists[m] + '_'+"Ostan"], Temp_Dict[Months_Lists[m] + '_'+"Direct_Mehvar"], Temp_Dict[Months_Lists[m] + '_'+"Direct_Ostan"]= Est_Orig_To_Dest(pd.read_excel('C:\\Users\\mahkam\\Desktop\\پروژه فرصت های ارسال مستقیم در شبکه تیپاکس\\Each_Node_Pickup.xlsx',sheet_name=Sheets[m]),Targets[m])
#     Estimated_Arr_Monthly.append(Temp_Dict)


Lats = pd.read_excel(r'C:\Users\mahkam\Desktop\پروژه فرصت های ارسال مستقیم در شبکه تیپاکس\Lats & Longs.xlsx',sheet_name = 'Node_Mehvar')
route1 = folium.Map(location = [29.61,52.57],popup='شیراز',zoom_start=5)
line = [(29.61,52.57),(31.31,48.68)]
folium.PolyLine(line, color='Green',weight=1.5,opacity=0.5).add_to(route1)
route1.save("Route1.html")
   
 

