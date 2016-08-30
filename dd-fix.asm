  * = $1e00

start:
  jsr install
  jmp $2051
  
install:  {
  sta storeA

  lda #<playMusicReplacement
  sta $aae0
  lda #>playMusicReplacement
  sta $aae1

  lda #<updateEnemyReplacement
  sta $228e
  lda #>updateEnemyReplacement
  sta $228f
  
  lda #$4c              // JMP
  sta $93e9
  lda #<printMessageReplacement
  sta $93ea
  lda #>printMessageReplacement
  sta $93eb
  
  lda #$20              // JSR
  sta $a448
  lda #<ciaInterruptPatch
  sta $a449
  lda #>ciaInterruptPatch
  sta $a44a

  lda #$20              // JSR
  sta $2566
  lda #<mainLoopPatch
  sta $2567
  lda #>mainLoopPatch
  sta $2568
  lda #$ea              // NOP
  sta $2569

  lda #$20              // JSR
  sta $9969
  lda #<b4SetupPatch
  sta $996a 
  lda #>b4SetupPatch
  sta $996b
 
  lda #$f8              // Update raster.
  sta $2294
  lda #$29              // AND
  sta $229b
  lda #$7f
  sta $229c

  lda #$31               // CIA timer.
  sta $a40a
  lda #$9f
  sta $a40f  

  lda #$4c              // JMP
  sta $2179
  lda #<irq2179
  sta $217a
  lda #>irq2179
  sta $217b

  lda #$4c              // JMP
  sta $994e
  lda #<irq994e
  sta $994f
  lda #>irq994e
  sta $9950

  lda #$4c              // JMP
  sta $a427
  lda #<irqa427
  sta $a428
  lda #>irqa427
  sta $a429

  lda #$4c              // JMP
  sta $23a9
  lda #<rti
  sta $23aa
  lda #>rti
  sta $23ab
  
  lda storeA
  rts
  }
  
playMusicReplacement:  {
  inc playMusicFlag
  rts
}

updateEnemyReplacement:  {
  inc updateEnemyFlag
  rts
}

printMessageReplacement:  {
  inc printMessageFlag
  rts
}
  
ciaInterruptPatch:  { // Play music in the CIA interrupt
  stx storeX
  sty storeY
  lda playMusicFlag
  beq skipMusic
  cli
  inc $d020
  jsr $1203
  dec $d020
skipMusic:
  lda #$00
  sta playMusicFlag
  ldx storeX
  ldy storeY
  sta $d020
  lda $a426
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

b4SetupPatch: { // Move the update enemy to $b4 irq setup.
  sta $d012
  lda updateEnemyFlag
  beq skipEnemy
  jsr $814a
skipEnemy:
  lda #$00
  sta updateEnemyFlag
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
  
zero:
  .byte 0

storeA:
  .byte 0
  
storeX:
  .byte 0

storeY:
  .byte 0
  
playMusicFlag:
  .byte 0

updateEnemyFlag:
  .byte 0

printMessageFlag:
  .byte 0
  
musicLoopCounter:
  .byte 0
  
