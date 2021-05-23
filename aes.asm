[bits 64]
global _start
extern exit
extern printf
extern puts
%macro  printInline 1
    mov rcx, %1
    sub rsp, 40
    call puts
    add rsp, 40
%endmacro


%macro  printInline 2
    mov rcx, %1
    mov rdx, [rel %2]
    sub rsp, 40
    call printf
    add rsp, 40
%endmacro

%macro  printInline 3
    mov rcx, %1
    mov rdx, [rel %2]
    mov r8,  [rel %3]
    sub rsp, 40
    call printf
    add rsp, 40
%endmacro

%macro aeskeygen 1
    aeskeygenassist xmm1, [rel %1], 69
    movups [rel %1], xmm1
%endmacro


section .text

_start:
; rcx  rdx  r8   r9   stack
; xmm0 xmm1 xmm2 xmm3 stack


    call checkAES

    printInline Decrypted,ourfloat,ourfloat+8
   
    pxor xmm1,xmm1

    ;rdseed should be supported when AES is
    rdseed rax
    mov [rel payloadkey], rax
    rdseed rax
    mov [rel payloadkey + 8], rax
        


    ; keygen 
    mov rdi, payloadkey
    mov rsi, garbagekey
    sub rsp, 40
    call loadkey
    add rsp, 40

   ; encrypt
    movups xmm0, [rel ourfloat]
    lea rdi, [rel garbagekey]
    pxor   xmm0, [rel rdi+0]
    aesenc xmm0, [rel rdi+16] ;1
    aesenc xmm0, [rel rdi+32] ;2
    aesenc xmm0, [rel rdi+48] ;3
    aesenc xmm0, [rel rdi+64] ;4
    aesenc xmm0, [rel rdi+80] ;5
    aesenc xmm0, [rel rdi+96] ;6
    aesenc xmm0, [rel rdi+112];7
    aesenc xmm0, [rel rdi+128];8
    aesenc xmm0, [rel rdi+144];9
    aesenclast xmm0, [rel rdi+160]
    movups [rel ourfloat], xmm0

    printInline encrypted,ourfloat,ourfloat+8


    ;decrypt

    mov rdi, [rel garbagekey]
    movups xmm0, [rel ourfloat]

    pxor xmm0,   [rel garbagekey+16*10]
    
    aesdec xmm0, [rel garbagekey+16*11];1
    aesdec xmm0, [rel garbagekey+16*12];2
    aesdec xmm0, [rel garbagekey+16*13];3
    aesdec xmm0, [rel garbagekey+16*14];4
    aesdec xmm0, [rel garbagekey+16*15];5
    aesdec xmm0, [rel garbagekey+16*16];6
    aesdec xmm0, [rel garbagekey+16*17];7
    aesdec xmm0, [rel garbagekey+16*18];8
    aesdec xmm0, [rel garbagekey+16*19];9
    aesdeclast xmm0,  [rel garbagekey]  
    movups [rel ourfloat], xmm0    
    
    printInline Decrypted,ourfloat,ourfloat+8


    xor ecx,ecx
    call exit



%include "gcccodegen.asm"

checkAES:
    mov eax, 1
    cpuid
    test ecx, 1 << 25
    jz abort
    printInline(aesmess)
    ret
    
abort:
    mov eax, 1
    xor edx, edx
    idiv edx

section .data
align 16
ourfloat: db `OUR MESsage`,0,0,0,0,0
payloadkey: 
    times 16 db 10
payloadkeyend:

section .bss
align 16
garbagekey:  resb 16*30


section .rodata
encrypted: db `Encrypted: %x%x\n`,0
Decrypted: db `Decrypted: %x%x\n`,0
aesmess: db `AES is supported`,0