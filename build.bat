# 1. Assemble the entry point stub
nasm -f win32 kernel_entry.asm -o entry.o

# 2. Compile the new C kernel logic
& "C:\msys64\mingw32\bin\gcc.exe" -ffreestanding -c kernel.c -o k_final.o

# 3. Link everything at address 0x1000
& "C:\msys64\mingw32\bin\ld.exe" -o kernel.tmp -Ttext 0x1000 entry.o k_final.o

# 4. Create the raw binary
& "C:\msys64\mingw32\bin\objcopy.exe" -O binary kernel.tmp kernel.bin

# 5. Join with your bootloader and pad to 32MB
cmd /c "copy /b boot.bin+kernel.bin PingOS.img"
$file = "PingOS.img"; $stream = [System.IO.File]::OpenWrite($file); $stream.SetLength(33554432); $stream.Close()