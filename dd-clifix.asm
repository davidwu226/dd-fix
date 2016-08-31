  * = $1e00

start:
  jsr install
  jmp $2051
  
install:  {
  sta storeA

  lda #$31               // CIA timer.
  sta $a40a
  lda #$9f
  sta $a40f  

  lda #$4c                      // JMP
  sta $2287
  sta $228a
  sta $228d
  sta $2290

  lda #<replace2287
  sta $2288
  lda #>replace2287
  sta $2289

  lda #<replace228a
  sta $228b
  lda #>replace228a
  sta $228c

  lda #<replace228d
  sta $228e
  lda #>replace228d
  sta $228f

  lda #<replace2290
  sta $2291
  lda #>replace2290
  sta $2292

  lda #$4c              // JMP
  sta $93e9
  lda #<printMessageReplacement
  sta $93ea
  lda #>printMessageReplacement
  sta $93eb

  lda #$20              // JSR
  sta $2566
  lda #<mainLoopPatch
  sta $2567
  lda #>mainLoopPatch
  sta $2568
  lda #$ea              // NOP
  sta $2569

  lda storeA
  rts
  }

replace2287:  {
  lda #$f8
  sta $d012
  lda $d011
  and #$7f
  sta $d011
  lda $75
  ldy $76
  ldx $77
  sta storeA
  sty storeY
  stx storeX
  cli
  jsr $3b56
  jsr $a19e
  jsr $814a
  jmp exit  
  } 

replace228a:  {
  lda #$f8
  sta $d012
  lda $d011
  and #$7f
  sta $d011
  lda $75
  ldy $76
  ldx $77
  sta storeA
  sty storeY
  stx storeX
  cli
  jsr $a19e
  jsr $814a
  jmp exit
  } 

replace228d: {
  lda #$f8
  sta $d012
  lda $d011
  and #$7f
  sta $d011
  lda $75
  ldy $76
  ldx $77
  sta storeA
  sty storeY
  stx storeX

  cli
  jsr $814a
  jmp exit
  } 

replace2290: {
  lda #$f8
  sta $d012
  lda $d011
  and #$7f
  sta $d011
  lda $75
  ldy $76
  ldx $77
  sta storeA
  sty storeY
  stx storeX
  cli
  }
  
exit:  {
  jsr $aada
  lda storeA
  ldy storeY
  ldx storeX
  rti
  }

printMessageReplacement:  {
  inc printMessageFlag
  rts
}

mainLoopPatch: { // Replacement for main loop
  lda printMessageFlag
  beq skipMessage
  lda #$00
  sta $a0
  jsr $93ed
skipMessage:  
  lda #$00
  sta printMessageFlag
  inc $ab
  lda $a9
  rts
  }  

irq2179:  {
  sta $75
  sty $76
  inc $d020
  jmp $217d
  }

irq994e:  {
  sta $75
  stx $77
  inc $d020
  jmp $9952
  } 

irqa427:
  sta $a426
  inc $d020
  jmp $a42a
  
rti:  {
  dec $d020
  lda $75
  ldy $76
  ldx $77
  rti
  }

storeA:
  .byte 0
storeX:
  .byte 0
storeY:
  .byte 0

printMessageFlag:
  .byte 0
