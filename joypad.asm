.include "nes.inc"

.export joypad1_read
.exportzp joypad1_state

.segment "ZEROPAGE"
  joypad1_state:  .res 1

.segment "CODE"

.proc joypad1_read
  lda #1
  sta JOYPAD1           ; Strobe the controller (latch button states)
  lda #0
  sta JOYPAD1           ; Stop latching

  ldx #8                ; Read 8 buttons
@read_buttons:
  lda JOYPAD1           ; Read button state
  lsr A                 ; Shift bit 0 into the carry flag
  ror joypad1_state     ; Roll the carry flag into joypad1_state
  dex
  bne @read_buttons     ; Repeat for all 8 buttons

  rts
.endproc
