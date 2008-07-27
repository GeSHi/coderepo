#!/usr/bin/gnuplot
reset
set terminal svg
set output "h2o_hcl.svg"
#set border 3
#set xtics nomirror
#set ytics nomirror
set size 1,1
set origin 0,0
set label "Wasser und Salzsäure" at screen .55, screen .55 center
set nokey
f(x) = m*x + c
# h2o + hcl:
set multiplot
set size 0.5,0.5
set points
# ph
set origin 0,.5
set xrange [0:15]
set xlabel "Volumen Salzsäure"
set yrange [0:8]
set ylabel "pH-Wert"
plot 'h2o_hcl.csv' using 1:2

# I
set origin 0,0
set yrange [0:90]
set ylabel "Leitfäuigkeit I [mA]"
plot 'h2o_hcl.csv' using 1:3

# ln(ph)
set origin .5,.5
set yrange [.45:0.92]
set xlabel "ln(VSalzsr/1000)"
set ylabel "ln(pH)"
set xrange [-4.1:-7]
fit f(x) 'h2o_hcl.csv' using 4:5 via m, c
plot 'h2o_hcl.csv' using 4:5,f(x)
#m               = -0.167495        +/- 0.002761     (1.649%)
#c               = -0.249187        +/- 0.01409      (5.656%)


# ln(I)
set origin .5,0
set yrange [-4.6:-2.4]
set ylabel "ln(I/mA)"
fit f(x) 'h2o_hcl.csv' using 4:6 via m, c
plot 'h2o_hcl.csv' using 4:6,f(x)
#m               = 0.730497         +/- 0.02538      (3.475%)
#c               = 0.650971         +/- 0.1296       (19.9%)
unset logscale

unset multiplot