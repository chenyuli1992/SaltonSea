import pandas as pd
from numpy import random
import numpy as np
from obspy import UTCDateTime
# read in catalog
df=pd.read_csv('catalogs/whole_2008_2013_new3_zmap_ss.dat',sep=' ')
df.columns=['longitude','latitude','year','month','day','magnitude','depth','hour','minute','second']
df["new"]=df['year'].map(str)+'-'+df['month'].map(str)+'-'+df['day'].map(str)+\
'T'+df['hour'].map(str)+':'+df['minute'].map(str)+':'+df['second'].map(str)
df.rename(columns={"new":'UTCTime'},inplace=True)
def convert_time(x):
    return UTCDateTime(x).timestamp
df["timestamp"] = df["UTCTime"].apply(convert_time)
df1=df[df['magnitude']>-0.5]

df2=pd.read_csv('1kp_2008_2014.csv')
df2["UTCTime"]=df2['date'].map(str)+'T'+df2['time']
df2["timestamp"] = df2["UTCTime"].apply(convert_time)

# calculate beta values 2 hours after mainshocks
text_file = open("beta_random.txt", "w")
L=len(df2)
beta=np.zeros(L)
thres=np.zeros(L)
for i in range(0,L):
    t0=df2['timestamp'][i]
#    ta=2*7200
    tb=60*86400
#    print(t0,ta,tb)
    b1=t0-tb
    e1=t0
#    b2=t0+df2['dist'][i]*111.1/7
#    e2=b2+ta
    b2=t0+df2['dist'][i]/7
    e2=t0+df2['dist'][i]/2+100
    ta=e2-b2
#    print(e2-b2)
    Nb=len(df1[(df1['timestamp']>b1) & (df1['timestamp']<e1)]) 
    Na=len(df1[(df1['timestamp']>b2) & (df1['timestamp']<e2)]) 
#    print(Nb,Na,tb,ta)
    N=Na+Nb
    T=ta+tb
    beta[i]=(Na-N*ta/T)/np.sqrt(N*ta/T*(1-ta/T))
#    print(beta[i])
    x=np.ones(10000)
    random_beta=np.zeros(10000)
    for j in range(0,10000):
        x[j]=random.uniform(b,e)
        start=x[j]
        otime=start+60*86400
        end=otime+ta
        T=end-start
        Nb=len(df1[(df1['timestamp']>start) & (df1['timestamp']<otime)]) 
        Na=len(df1[(df1['timestamp']>otime) & (df1['timestamp']<end)]) 
        N=Na+Nb
        random_beta[j]=(Na-N*ta/T)/np.sqrt(N*ta/T*(1-ta/T))
    thres[i]=np.percentile(random_beta, 95)
    print(i,beta[i],thres[i])
    text_file.write("%s %s %s %s\n" % (df2['date'][i], df2['time'][i], beta[i], thres[i]))
text_file.close()
