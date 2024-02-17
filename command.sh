#!/bin/bash

bison -Wno-conflicts-sr -Wno-conflicts-rr  --header  2005017.y
echo 'Generated the 2005017 C file as well the header file'
g++ -w -c -o y.o 2005017.tab.c
echo 'Generated the 2005017 object file'
#flex scanner.l
flex 2005017.l
echo 'Generated the scanner C file'
g++ -w -c -o l.o lex.yy.c
# if the above command doesn't work try 
# g++ -fpermissive -w -c -o l.o lex.yy.c
echo 'Generated the scanner object file'
g++ y.o l.o -lfl -o 2005017
echo 'All ready, running'
# ./2005017 errorrecover.c
# ./2005017 noerror.c
# ./2005017 sserror.c
./2005017 inp.c

rm lex.yy.c l.o y.o 2005017.tab.c 2005017.tab.h 2005017
