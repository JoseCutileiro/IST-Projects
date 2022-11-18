#!/usr/bin/gnuplot

set logscale x 2;
plot "cm1_plot.dat" using 1:2 with lines title "8kB",  \
     "cm1_plot.dat" using 1:3 with lines title "16kB", \
     "cm1_plot.dat" using 1:4 with lines title "32kB", \
     "cm1_plot.dat" using 1:5 with lines title "64kB";

pause mouse
