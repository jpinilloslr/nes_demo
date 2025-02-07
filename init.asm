; Initialization subroutines
.include "nes.inc"

.export clear_ram
.export wait_for_vblank
.export enable_rendering
.export game_loop

.segment "CODE"

.proc clear_ram
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

.proc wait_for_vblank
@loop:
  bit PPU_STATUS
  bpl @loop
  rts
.endproc

.proc enable_rendering
  lda #%10000000  ; Enable NMI (VBlank interrupt)
  sta PPU_CTRL
  lda #%00011110  ; Enable sprites and background
  sta PPU_MASK
  rts
.endproc

.proc game_loop
@forever:
  jmp @forever
.endproc
