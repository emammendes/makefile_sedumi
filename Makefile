# This is a makefile to compile sedumi using intel studio on mac
#
# I had to modify the following files due to compilation errors:
#
# blkmul.c 
#
# 1) Add line "int blkmulsize;"
# 2) Fix line "nL = (mwindex *) mxCalloc(MAX(1,kappa), sizeof(mwIndex));" mwIndex and not mwindex
# 
# symbchol.c
#
# 1) Line "perm   = (mwIndex *) mxCalloc(m,sizeof(mwIndex));" -> add perm to the list of mwIndex vars
# 2) Line "iwork = (mwIndex *) mxCalloc(iwsiz,sizeof(mwIndex));"-> ditto
# 3) Line "xlindx = (mwIndex *) mxCalloc(m+1,sizeof(mwIndex));" -> ditto
# 4) Lir, Ljc are not declated -> int *Lir, *Ljc and then (int *) mxCalloc(m+1,sizeof(int));
#
# Obs.:  I am not sure about the sizes of Lir and Ljc
#
# symbchol.h 
#
# The header file was created to remove the compilation error when using gcc.  An implicit declation of a function
# was added.
#
# blkchol.h
# 
# "touch blkchol.h"  (Perhaps the authors forgot to remove this header from some of the files"
# 
# Instructions:
#
# To create mex functions do: 
#
# make all (to create the obj files and the mex binaries) 
#
# Eduardo Mendes - 05/01/2018 - with lots of help specially from Prof. Renaud Pacalet

# define matlab dir
# Change to the proper dir in your mac
MDIR = /Applications/MATLAB_R2017b.app

# compiles mex files using gcc
CC = gcc

# compiler flags for gcc
# To avoid lots of warning msgs I have added two -Wno
CCFLAGS = -O3 -fpic -march=x86-64 -Wno-implicit-function-declaration -Wno-pointer-sign

# to use the intel compiler instead, uncomment CC and CCFLAGS below:

# compiles mex file using the intel compiler
#CC = icc

# compiler flags for intel compiler
#CCFLAGS = -O3 -fPIC -D__amd64

# Figure out which platform we're on
UNAME = $(shell uname -s)

# Linux
ifeq ($(findstring Linux,${UNAME}), Linux)
	# define which files to be included
	CINCLUDE = -I$(MDIR)/extern/include -Ic++ -shared
	# define extension
	EXT = mexa64
endif

# Mac OS X
ifeq ($(findstring Darwin,${UNAME}), Darwin)
	# define which files to be included
	CINCLUDE = -L$(MDIR)/bin/maci64 -Ic++ -shared -lmx -lmex -lmat -lmwblas
	# define extension
	EXT = mexmaci64
	# CCFLAGS += -std=c++11 
endif

# All rules as object files

OBJ0:=bwblkslv.o sdmauxFill.o sdmauxRdot.o
OBJ1:=choltmpsiz.o
OBJ2:=cholsplit.o
OBJ3:=dpr1fact.o auxfwdpr1.o sdmauxCone.o  sdmauxCmp.o sdmauxFill.o sdmauxScalarmul.o sdmauxRdot.o blkaux.o
OBJ4:=symfctmex.o symfct.o
OBJ5:=ordmmdmex.o ordmmd.o
OBJ6:=quadadd.o
OBJ7:=sqrtinv.o sdmauxCone.o
OBJ8:=givensrot.o auxgivens.o sdmauxCone.o
OBJ9:=urotorder.o auxgivens.o sdmauxCone.o sdmauxTriu.o sdmauxRdot.o
OBJ10:=psdframeit.o reflect.o sdmauxCone.o sdmauxRdot.o sdmauxTriu.o sdmauxScalarmul.o
OBJ11:=psdinvjmul.o reflect.o sdmauxCone.o sdmauxRdot.o sdmauxTriu.o sdmauxScalarmul.o blkaux.o
OBJ12:=bwdpr1.o sdmauxCone.o sdmauxRdot.o
OBJ13:=fwdpr1.o auxfwdpr1.o sdmauxCone.o sdmauxScalarmul.o
OBJ14:=fwblkslv.o sdmauxScalarmul.o
OBJ15:=qblkmul.o sdmauxScalarmul.o
OBJ16:=blkchol.o blkchol2.o sdmauxFill.o sdmauxScalarmul.o
OBJ17:=vecsym.o sdmauxCone.o
OBJ18:=qrK.o sdmauxCone.o sdmauxRdot.o sdmauxScalarmul.o
OBJ19:=finsymbden.o sdmauxCmp.o
OBJ20:=symbfwblk.o
OBJ21:=whichcpx.o sdmauxCone.o
OBJ22:=ddot.o sdmauxCone.o sdmauxRdot.o sdmauxScalarmul.o
OBJ23:=makereal.o sdmauxCone.o sdmauxCmp.o
OBJ24:=partitA.o sdmauxCmp.o
OBJ25:=getada1.o sdmauxFill.o
OBJ26:=getada2.o sdmauxCone.o sdmauxRdot.o sdmauxFill.o
OBJ27:=getada3.o spscale.o sdmauxCone.o sdmauxRdot.o sdmauxScalarmul.o sdmauxCmp.o
OBJ28:=adendotd.o sdmauxCone.o
OBJ29:=adenscale.o
OBJ30:=extractA.o
OBJ31:=vectril.o sdmauxCone.o sdmauxCmp.o
OBJ32:=qreshape.o sdmauxCone.o sdmauxCmp.o
OBJ33:=sortnnz.o sdmauxCmp.o
OBJ34:=iswnbr.o
OBJ35:=incorder.o
OBJ36:=findblks.o sdmauxCone.o sdmauxCmp.o
OBJ37:=invcholfac.o triuaux.o sdmauxCone.o sdmauxRdot.o sdmauxTriu.o sdmauxScalarmul.o blkaux.o

OBJVARS := OBJ0  OBJ1  OBJ2  OBJ3  OBJ4  OBJ5  OBJ6  OBJ7  OBJ8  OBJ9 OBJ10 OBJ11 OBJ12 OBJ13 OBJ14 OBJ15 OBJ16 OBJ17 OBJ18 OBJ19 BJ20 OBJ21 OBJ22 OBJ23 OBJ24 OBJ25 OBJ26 OBJ27 OBJ28 OBJ29 OBJ30 OBJ31 OBJ32 OBJ33 OBJ34 OBJ35 OBJ36 OBJ37


# Sources and object files

SRC := $(wildcard *.c)
OBJ := $(patsubst %.c,%.o,$(SRC))

# Object files

$(OBJ): %.o: %.c
	$(CC) $(CCFLAGS) -I$(MDIR)/extern/include -c -Ic++ $< -o $@

# Mex functions

.PHONY: all clean install

EXTS :=

# $(1): variable name
define MY_rule
$(1)_EXT := $$(patsubst %.o,%.$$(EXT),$$(firstword $$($(1))))

EXTS += $$($(1)_EXT)

$$($(1)_EXT): $$($(1))
	$$(CC) $$(CCFLAGS) $$(CINCLUDE) $$^ -o $$@
endef

$(foreach v,$(OBJVARS),$(eval $(call MY_rule,$(v))))

all: $(EXTS)

clean:
	rm -f $(OBJ) $(EXTS)
	