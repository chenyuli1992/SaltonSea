function [t,M,lat,lon,depth]= ReadANSS(F)

    id=fopen(F); 
    A=textscan(id,'%s %s %s %f %s  %f %f %f %s %*[^\n]','headerlines',3);
    %A=textscan(id,'%s %s %f %f %f %f %s %*[^\n]','headerlines',2);
    fclose(id);
    
    lat=A{6};
    lon=A{7};
    depth=A{8};
    
    M=A{4};
    
    t1=datenum(A{1});
    t2=datenum(A{2});
    t0=datenum('00:00:00');
    t=t1+t2-t0;
    
    
    
    