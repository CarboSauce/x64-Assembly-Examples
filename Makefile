aes.obj: aes.asm
	nasm -fwin64 aes.asm -o aes.obj

aes.exe: aes.obj
	gcc -nostartfiles aes.obj -o aes.exe
.PHONY: run clean
run: aes.exe
	./aes.exe

clean: aes.exe aes.obj
	rm aes.exe aes.obj