;; palettes.asm
.include "nes.inc"

.export load_palettes

.segment "CODE"

.proc load_palettes
  lda PPU_STATUS       ; Reset PPU latch
  lda #$3f
  sta PPU_ADDR         ; Set PPU address to $3F00 (palette memory)
  lda #$00
  sta PPU_ADDR
  ldx #$00
@loop:
  lda palettes, x
  sta PPU_DATA         ; Write palette data to PPU
  inx
  cpx #$20             ; Load 32 bytes
  bne @loop
  lda #0
  sta PPU_SCROLL       ; Reset horizontal scroll
  sta PPU_SCROLL       ; Reset vertical scroll
  rts
.endproc

palettes:
  ; Background Palettes
  .byte $0F, $11, $00, $00   ; Background Palette 0
  .byte $0F, $18, $28, $0D   ; Background Palette 1
  .byte $0F, $1A, $08, $0D   ; Background Palette 2
  .byte $0F, $00, $00, $00   ; Background Palette 3

  ; Sprite Palettes
  .byte $0F, $2A, $16, $0D   ; Sprite Palette 0
  .byte $0F, $15, $38, $0D   ; Sprite Palette 1
  .byte $0F, $00, $00, $00   ; Sprite Palette 2
  .byte $0F, $00, $00, $00   ; Sprite Palette 3
