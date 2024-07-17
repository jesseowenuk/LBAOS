#! /bin/bash

# cleaning the existing files
echo "Peforming clean up..."
rm *.bin

# assemble the bootsector
echo "Assembling the Bootsector..."
nasm -f bin -o bootsector.bin bootsector.asm

# assemble the kernel
echo "Assembling the Kernel..."
nasm -f bin -o kernel.bin kernel.asm

# join the files together
echo "Joining the files together.."
cat bootsector.bin kernel.bin > LBAOS.bin

# lets send it!
echo "Sending it...."
qemu-system-i386 -fda LBAOS.bin