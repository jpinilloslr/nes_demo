; Initialization subroutines
.include "nes.inc"

.export ClearRAM
.export WaitForVBlank
.export EnableRendering
.export GameLoop

.segment "CODE"

.proc ClearRAM
  ldx #$00
  lda #$00
@loop:
  sta $0000, x
  ;sta $0100, x     ; Commented out, as we don't want to clear the stack
  sta $0200, x
  sta $0300, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  inx
  bne @loop         ; Loop until X wraps to 0
  rts
.endproc

.proc WaitForVBlank
@loop:
  bit PPU_STATUS
  bpl @loop
  rts
.endproc

.proc EnableRendering
  lda #%10000000  ; Enable NMI (VBlank interrupt)
  sta PPU_CTRL
  lda #%00011110  ; Enable sprites and background
  sta PPU_MASK
  rts
.endproc

.proc GameLoop
@forever:
  jmp @forever
.endproc
