#!/bin/bash

PATH=/opt/mips32-mti-elf/2019.09-03-2/bin/:$PATH ./configure --arch=mips --target-os=none --cross-prefix=mips-mti-elf-
make
