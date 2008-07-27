if (!exists("customtitle")) customtitle = ""

set term png interlace enhanced tiny font "/usr/share/fonts/truetype/ttf-dejavu/DejaVuSans.ttf" size 1200, 800
set grid xtics mxtics ytics mytics lt 49 lw 1, lt 0 lw 1
set key outside right top

# time vs loc
set output imgbase.'_loc_vs_time.png'
set title customtitle.'  time over linenumbers'
set ylabel 'time in s'
set xlabel 'linenumber'
set xtics 100 out rotate by 90
set mxtics 4
#set ytics 100
#set mytics 4
set mytics 10
plot data using 7:1 notitle with points

# memory diff ordinate
set output imgbase.'_memdiff_vs_loc.png'
set title customtitle.' Memory differences over linenumber - memory before: '.membefore.' after: '.memafter.' diff: '.memdiff.' peak: '.peakmem
set xlabel 'line number'
set ylabel 'memory difference in KB'
set xtics 100 out rotate by 90
set mxtics 4
#set ytics 100
#set mytics 4
set mytics 10
set logscale y
#plot data using 7:($6/1024) notitle with points
plot data using 7:($6 > 0 ? $6/1024 : 1/0 ) title "alloc" with points lt 1, data using 7:($6 < 0 ? -$6 / 1024 : 1/0) title "dealloc" with points lt 2
unset logscale y

# memory ordinate
set ytics 500
set mytics 5

set output imgbase.'_mem_vs_time.png'
set title customtitle.' Memory over Time - speed: '.speed.' total time: '.time.' memory before: '.membefore.' after: '.memafter.' diff: '.memdiff.' peak: '.peakmem
set xlabel 'time in sec'
set ylabel 'memory in KB'
# time
set xtics autofreq
set mxtics 5
plot data using 1:($4/1024) title "entry" with points, data using 1:($5/1024) title "exit"

set output imgbase.'_mem_vs_loc.png'
set title customtitle.' Memory over LinesOfCode - memory before: '.membefore.' after: '.memafter.' diff: '.memdiff.' peak: '.peakmem
set xlabel 'line of code'
set ylabel 'memory in KB'
# loc
set xtics 100 out rotate by 90
set mxtics 4
plot data using 7:($4/1024) title "entry" with points, data using 7:($5/1024) title "exit"

# loc ordinate
set output imgbase.'_loc_vs_timediff.png'
set title customtitle.' Time differences over LinesOfCode - speed: '.speed.' total time: '.time
set logscale y
set ytics autofreq
set mytics 10
set format y "%.1e"
set ylabel 'timediff in sec'
plot data using 7:3 notitle with points

# code coverage
set output imgbase.'_coverage_vs_loc.png'
set title customtitle.' Coverage of linenumbers (i.e. how often got function X get called in line Y)'
set xlabel 'line number'
set ylabel 'coverage (number of calls)'
set xtics 100 out rotate by 90
set mxtics 4
plot coveragedata using 1:2 notitle with impulses