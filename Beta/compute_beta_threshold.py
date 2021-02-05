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
# read in mainshocks
df2=pd.read_csv('1kp_2008_2014.csv')
df2["UTCTime"]=df2['date'].map(str)+'T'+df2['time']
df2["timestamp"] = df2["UTCTime"].apply(convert_time)

t1=UTCDateTime('2008-01-01')
t2=UTCDateTime('2013-12-31')
b=t1.timestamp
e=t2.timestamp

# calculate beta values 2 hours after mainshocks
text_file = open("beta_random_zvalue_new.txt", "w")
#text_file = open("zvalues.txt", "w")
L=len(df2)
beta=np.zeros(L)
zvalue=np.zeros(L)
thres=np.zeros(L)
for i in range(0,L):
#for i in range(9,10):
    print(i)
    t0=df2['timestamp'][i]
#    ta=2*7200
    tb=60*86400
#    print(t0,ta,tb)
    b1=t0-tb
    e1=t0
#    b2=t0+df2['dist'][i]*111.1/7
#    e2=b2+ta
    b2=t0+df2['dist'][i]/7
#    e2=t0+df2['dist'][i]/2+100
    e2=t0+df2['dist'][i]/2+200
#    e2=t0+7200 # only for 2011-03-11 earthquake
    ta=e2-b2
#    print(e2-b2)
    Nb=len(df1[(df1['timestamp']>b1) & (df1['timestamp']<e1)]) 
    Na=len(df1[(df1['timestamp']>b2) & (df1['timestamp']<e2)]) 
#    print(Nb,Na,tb,ta)
    N=Na+Nb
    T=ta+tb
    beta[i]=(Na-N*ta/T)/np.sqrt(N*ta/T*(1-ta/T))
    zvalue[i]=(Na*tb-Nb*ta)/np.sqrt(Na*tb*tb+Nb*ta*ta)
    b20=b2-t0
    e20=e2-t0
    Na0=Na
    Nb0=Nb
#    text_file.write("%s %s %s %s %s %s %s\n" % (beta[i],zvalue[i],ta,b20,e20,Na,Nb))
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
#    print(df2['date'][i], df2['time'][i],beta[i],thres[i],zvalue[i],ta,b20,e20,Na0,Nb0)
    text_file.write("%s %s %s %s %s %s %s %s %s %s\n" % (df2['date'][i], df2['time'][i], beta[i], thres[i],zvalue[i],ta,b20,e20,Na0,Nb0))
text_file.close()

