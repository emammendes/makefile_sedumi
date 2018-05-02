# makefile_sedumi

A Makefile (in a command line not within Matlab) to compile sedumi using gcc (Apple LLVM version 9.1.0 (clang-902.0.39.1)) and intel compiler (icc (ICC) 17.0.4 20170411). It worked flawlessly on my mac running Matlab 2017b.   

## Original Sedumi info

All the necessary information and source code were retrieved from [sedumi fork](https://github.com/sqlp/sedumi/). Please visit that web page for the necessary information

## What has been modified

To get the makefile working (*icc* and *gcc* problems) I had to create new header files and modify some c sources.  

**blkmul.c**

1. Add line "int blkmulsize;"
2. Fix line "nL = (mwindex \*) mxCalloc(MAX(1,kappa), sizeof(mwIndex));" mwIndex and not mwindex
 
**symbchol.c**

1. Line "perm   = (mwIndex \*) mxCalloc(m,sizeof(mwIndex));" -> add perm to the list of mwIndex vars
2. Line "iwork = (mwIndex \*) mxCalloc(iwsiz,sizeof(mwIndex));"-> ditto
3. Line "xlindx = (mwIndex \*) mxCalloc(m+1,sizeof(mwIndex));" -> ditto
4. Lir, Ljc are not declated -> int \*Lir, \*Ljc and then (int \*) mxCalloc(m+1,sizeof(int));
5. \#include "symbchol.h"

Obs.:  I am not sure about the sizes of Lir and Ljc

**symbchol.h**

The header file was created to remove the compilation error when using gcc.  An implicit declation of a function was added as follows:

void getadj(mwIndex \*forjc,mwIndex \*forir,const mwIndex \*cjc,const mwIndex \*cir,const mwIndex n);

**blkchol.h**
 
"touch blkchol.h"  (Perhaps the authors forgot to remove this header from some of the files"
 
##Instructions:

To create mex functions do: 

1. Go to sedumi-master dir
2. Make the changes in the files listed above and create the header files.
3. Issue *make all* (to create all obj files and mex binaries) 
