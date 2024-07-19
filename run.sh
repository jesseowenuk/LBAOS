#! /bin/bash

# cleaning the existing files
echo "Peforming clean up..."
rm *.bin

# assemble the bootsector
echo "Assembling the Bootsector..."
nasm -f bin -o bootsector.bin bootsector.asm

# assemble stage 2
echo "Assembling stage 2..."
nasm -f bin -o stage2.bin stage2.asm

# join the files together
echo "Joining the files together.."
cat bootsector.bin stage2.bin > LBAOS.bin

# lets send it!
echo "Sending it...."
qemu-system-i386 -fda LBAOS.bin