keyexpand:
  movaps xmm2, xmm0
  pshufd xmm1, xmm1, 255
  pslldq xmm2, 4
  xorps xmm2, xmm0
  movaps xmm0, xmm2
  pslldq xmm0, 4
  xorps xmm2, xmm0
  movaps xmm0, xmm2
  pslldq xmm0, 4
  xorps xmm0, xmm1
  xorps xmm0, xmm2
  ret
pubkeypand:
  push rax
  movups xmm0,  [rdi]
  aeskeygenassist xmm1, xmm0, 1
  movaps  [rsi], xmm0
  call keyexpand
  aeskeygenassist xmm1, xmm0, 2
  movaps  [rsi+16], xmm0
  call keyexpand
  aeskeygenassist xmm1, xmm0, 4
  movaps  [rsi+32], xmm0
  call keyexpand
  aeskeygenassist xmm1, xmm0, 8
  movaps  [rsi+48], xmm0
  call keyexpand
  aeskeygenassist xmm1, xmm0, 16
  movaps  [rsi+64], xmm0
  call keyexpand
  aeskeygenassist xmm1, xmm0, 32
  movaps  [rsi+80], xmm0
  call keyexpand
  aeskeygenassist xmm1, xmm0, 64
  movaps  [rsi+96], xmm0
  call keyexpand
  aeskeygenassist xmm1, xmm0, 128
  movaps  [rsi+112], xmm0
  call keyexpand
  aeskeygenassist xmm1, xmm0, 27
  movaps  [rsi+128], xmm0
  call keyexpand
  movaps  [rsi+144], xmm0
  aeskeygenassist xmm1, xmm0, 54
  call keyexpand
  movaps  [rsi+160], xmm0
  pop rdx
  ret


loadkey:
        push    rax
        call    pubkeypand
        aesimc  xmm0,  [rsi+144]
        movaps   [rsi+176], xmm0
        aesimc  xmm0,  [rsi+128]
        movaps   [rsi+192], xmm0
        aesimc  xmm0,  [rsi+112]
        movaps   [rsi+208], xmm0
        aesimc  xmm0,  [rsi+96]
        movaps   [rsi+224], xmm0
        aesimc  xmm0,  [rsi+80]
        movaps   [rsi+240], xmm0
        aesimc  xmm0,  [rsi+64]
        movaps   [rsi+256], xmm0
        aesimc  xmm0,  [rsi+48]
        movaps   [rsi+272], xmm0
        aesimc  xmm0,  [rsi+32]
        movaps   [rsi+288], xmm0
        aesimc  xmm0,  [rsi+16]
        movaps   [rsi+304], xmm0
        pop     rdx
        ret