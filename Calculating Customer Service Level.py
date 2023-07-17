import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sb
from datetime import datetime
w = 0
Undelivered_Carton = 0
sourcedf = pd.read_excel(r'C:\Users\m.vafaeinejad\Desktop\data3.xlsx')
sourcedf.drop(columns = ['کارتن مرجوعی','CSL%','ارائه خدمات','حواله تا توزیع','سفارش تا حواله','تاخیرات'],inplace=True)
sourcedf['OrderToVoucher'] = np.NAN
sourcedf['VoucherToDelivery'] = np.NAN
sourcedf['ServiceTime'] = np.NAN
sourcedf['CSL'] = np.NAN
for i in range(sourcedf.shape[0]):
    sourcedf.iloc[i,9]= (datetime.strptime(sourcedf.iloc[i,6],"%Y/%m/%d") - datetime.strptime(sourcedf.iloc[i,5],"%Y/%m/%d")).days
    sourcedf.iloc[i,10]= (datetime.strptime(sourcedf.iloc[i,7],"%Y/%m/%d") - datetime.strptime(sourcedf.iloc[i,6],"%Y/%m/%d")).days
    sourcedf.iloc[i,11]= sourcedf.iloc[i,9] + sourcedf.iloc[i,10]
    if sourcedf.iloc[i,11] <= 2:
        sourcedf.iloc[i,12] = 100
    else:
        Undelivered_Carton += sourcedf.iloc[i,3] 
        w += sourcedf.iloc[i,4]
        sourcedf.iloc[i,12] = 0
undelivered_customers = sourcedf.query('CSL== 0')
#undelivered_customers.to_excel(r'C:\Users\m.vafaeinejad\Desktop\Undelivered_Customers.xlsx')
Critical_Customers = sourcedf.query('ServiceTime>8')
Not_Critical_Customers = sourcedf.query('ServiceTime<3')
Mediocre_Customers = sourcedf.query('ServiceTime')
custms = list(Critical_Customers.iloc[:,0])
servtms = list(Critical_Customers.iloc[:,11])
#medium_customers = list(Critical_Customers.iloc[:,8])
plt.bar(custms,servtms,color='maroon')
plt.xticks(fontsize=6,fontname='monospace')
print('The number of delayed carton:{} '.format(Undelivered_Carton))
print('Undelivered Cartons Of Critical Customers:{}'.format(np.sum(Critical_Customers.iloc[:,3])))

