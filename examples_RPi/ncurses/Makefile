#############################################################################
#
# Makefile for librf24mesh examples on Raspberry Pi
#
# By:  TMRh20
# Date:    2013/09
#
# Description:
# ------------
# use make all and make install to install the examples
# You can change the install directory by editing the prefix line
#
prefix := /usr/local

# Assuming Raspberry Pi (original) / Raspberry Pi Zero
CCFLAGS=-O2 -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s -std=c++0x -Wall
# -- Check for Raspberry Pi 2+ --
ifeq "$(shell uname -m)" "armv7l"
# Set $CCFLAGS for Raspberry Pi 2+
CCFLAGS=-march=armv7-a -mtune=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -O2 -Wall -pthread -pipe -fstack-protector --param=ssp-buffer-size=4 -std=c++0x
endif

# define all programs
PROGRAMS = RF24Mesh_Ncurses_Master
SOURCES = ${PROGRAMS2:=.cpp}

all: ${PROGRAMS}

${PROGRAMS}: ${SOURCES}
	g++ ${CCFLAGS} -Wall -I../ -lncurses -lrf24-bcm -lrf24network -lrf24mesh $@.cpp -o $@

clean:
	rm -rf $(PROGRAMS)
	
install: all
	test -d $(prefix) || mkdir $(prefix)
	test -d $(prefix)/bin || mkdir $(prefix)/bin
	for prog in $(PROGRAMS); do \
	  install -m 0755 $$prog $(prefix)/bin; \
	done

.PHONY: install
