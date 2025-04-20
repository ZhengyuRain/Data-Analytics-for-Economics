
* var_bos

clear
set mem 10g
set more off

global transactions boston_jan08-feb09_v2

global currentcity bos
global currentzone 15

global datadir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/data
global bigdatadir /data/gsb/SBC/trx_data

global statadir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/stata
cd $statadir

global logdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/logs
global graphdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/graphs

global postingdate_nyc 04,01,2008
global postingdate_sea 01,03,2009

