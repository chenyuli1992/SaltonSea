function [t,M,lat,lon,depth]= Readhs(F)

    id=fopen(F);
    A=textscan(id,'%f %f %f %f %f %f %f %f %f %f %f %s %*[^\n]','headerlines',0);
    fclose(id);
    
    lat=A{8};
    lon=A{9};
    depth=A{10};
    
    M=A{11};
    
    t=datenum(A{1:6});
%     t2=datenum(A{4:6});
%     t0=datenum('00:00:00');
%     t=t1+t2-t0;
    
    
    
    