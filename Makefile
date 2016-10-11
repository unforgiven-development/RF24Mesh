#############################################################################
#
# Makefile for RF24Mesh on Raspberry Pi
#
# Author:  TMRh20 
# Date:    2014/09 
#
# Description:
# ------------
# use make all and make install to install the library 
# You can change the install directory by editing the LIB_DIR line
#

REL_RF24_MAKEFILE_INC="../RF24/Makefile.inc"
RF24_MAKEFILE_INC=$(shell echo "$$(cd "$$(dirname "$(REL_RF24_MAKEFILE_INC)")"; pwd)/$$(basename "$(REL_RF24_MAKEFILE_INC)")")

ifneq ("$(wildcard $(RF24_MAKEFILE_INC))","")
RF24_MAKEFILE_INC_EXISTS=1
else
RF24_MAKEFILE_INC_EXISTS=0
endif

ifeq ($(RF24_MAKEFILE_INC_EXISTS),1)
# $(RF24_MAKEFILE_INC) DEFINES:
# - CFLAGS
# - PREFIX
# - CC
# - CXX
# - LDCONFIG
# - LIB_DIR
# - EXAMPLES_DIR
include $(RF24_MAKEFILE_INC)
else
PREFIX=/usr/local
LIB_DIR=$(PREFIX)/lib
EXAMPLES_DIR=$(PREFIX)/bin
CC=gcc
CXX=g++
LDCONFIG=ldconfig
# CFLAGS #
## Assuming Raspberry Pi (original) / Raspberry Pi Zero ##
CFLAGS=-march=armv6zk -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard -O2 -pthread -pipe -fstack-protector --param=ssp-buffer-size=4 -std=c++0x
## -- Check for Raspberry Pi 2+ -- ##
ifeq "$(shell uname -m)" "armv7l"
## Set CFLAGS for Raspberry Pi 2+ ##
CFLAGS=-march=armv7-a -mtune=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -O2 -pthread -pipe -fstack-protector --param=ssp-buffer-size=4 -std=c++0x
endif

endif
# (end of RF24_MAKEFILE_INC_EXISTS)


# LIBRARY PARAMETERS #
## library name ##
LIB_RFN=librf24mesh
## shared library name ##
LIBNAME_RFN=$(LIB_RFN).so.1.0
## includes/headers directory ##
HEADER_DIR=$(PREFIX)/include/RF24Mesh

# make all
# reinstall the library after each recompilation
all: librf24mesh

# Make the library
librf24mesh: RF24Mesh.o
	${CXX} -shared -Wl,-soname,$@.so.1 ${CFLAGS} -o ${LIBNAME_RFN} $^ 

# Library parts
RF24Mesh.o: RF24Mesh.cpp
	${CXX} -Wall -fPIC ${CFLAGS} -c $^

# clear build files
clean:
	rm -rf *.o ${LIB_RFN}.*

install: install-libs install-headers

# Install the library to LIBPATH

install-libs: 
	@echo "[Install]"
	@if ( test ! -d $(LIB_DIR) ) ; then mkdir -p $(LIB_DIR) ; fi
	@install -m 0755 ${LIBNAME_RFN} ${LIB_DIR}
	@ln -sf ${LIB_DIR}/${LIBNAME_RFN} ${LIB_DIR}/${LIB_RFN}.so.1
	@ln -sf ${LIB_DIR}/${LIBNAME_RFN} ${LIB_DIR}/${LIB_RFN}.so
	@ldconfig

install-headers:
	@echo "[Installing Headers]"
	@if ( test ! -d $(HEADER_DIR) ) ; then mkdir -p $(HEADER_DIR) ; fi
	@install -m 0644 *.h ${HEADER_DIR}

# simple debug function
print-%:
	@echo $*=$($*)

.PHONY: install