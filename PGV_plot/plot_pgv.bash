#!/bin/bash

outmap="PGV_lp1_new.ps"
#outmap="PGV_lp1_more.ps"

awk '{if (NR<=27) print $5,$3*100}' pgv_dist_lp1.dat | \
psxy -R10/30000/0.01/3 -JX6l/5.5l -Ba1f3p:"Distance (km)":\
/a1f3p:"Peak Ground Velocity(cm/s)":WeSn -Sc0.12 -W1p/black -P -K -Y1.5 -X1.2 > $outmap

#awk '{if (NR==1 || NR==4 || NR==8 || NR==9 || NR==10 || NR==11 || NR==14 || NR==26 ) print $5,$3*100}' pgv_dist_lp1.dat | \
awk '{if (NR==4 || NR==11) print $5,$3*100}' pgv_dist_lp1.dat |\
psxy -R -JX -Sc0.12 -W1p/black -Gred -O -P -K >> $outmap

#awk '{if (NR==9) print $5,$3*100}' pgv_dist_lp1.dat |\
#psxy -R -JX -Sc0.12 -W1p/black -Gblue -O -P -K >> $outmap

#awk '{if ( NR==26) print $5,$3*100}' pgv_dist_lp1.dat | \
#psxy -R -JX -Sc0.12 -W1p/black -Ggray -O -P -K >> $outmap

awk '{if ( NR==8 || NR==14) print $5,$3*100}' pgv_dist_lp1.dat | \
psxy -R -JX -SC0.12 -W1p/black -Gred -O -P -K >> $outmap


#awk '{print $5,$3*100*1.08, "12 0 0 CB "substr($1,1,8)+1}' pgv_dist_lp1.dat > text_pgv.txt
awk '{if (NR<14) print}' text_pgv.txt | pstext  -R -JX -P -O -K  >> $outmap
#echo "15 2.7 14 0 0 CT (a)" | pstext -R -JX -P -O -K >> $outmap
#(x,y,size,angle,fontno,justify,text)

echo "20 0.06 12 0 0 CT 5KPa"  | pstext -R -JX -P -O -K >> $outmap
echo "20 0.12 12 0 0 CT 10KPa"  | pstext -R -JX -P -O -K >> $outmap
echo 1 1 | psxy -R10/30000/1/300 -JX6l/5.5l -Ba1f3:"":/a1f3:"Dynamic Stress(kpa)":E -Sc0.01 -P -O -K >> $outmap
#legend
pslegend -Dx0.1/0.1/1.3/0.50/BL -JX -R -F -K -O << EOF >> $outmap
S 0.15 c 0.10 red 1p/black 0.6c Triggered 
S 0.15 c 0.10 - 1p/black 0.6c No Trigger 
EOF

psxy -R -JX -m -W1p,red,'-' -P -O -K << END >> $outmap
10 5
36000 5
END

psxy -R -JX -m -W1p,red,'-' -P -O << END >> $outmap
10 10
36000 10
END
