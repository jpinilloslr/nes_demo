.include "nes.inc"

.export LoadPalettes

.segment "CODE"

.proc LoadPalettes
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
  rts
.endproc

palettes:
  ; Background Palettes
  .byte $0F, $00, $00, $00   ; Background Palette 0
  .byte $0F, $00, $00, $00   ; Background Palette 1
  .byte $0F, $00, $00, $00   ; Background Palette 2
  .byte $0F, $00, $00, $00   ; Background Palette 3

  ; Sprite Palettes
  .byte $0F, $17, $07, $2A   ; Sprite Palette 0
  .byte $0F, $00, $00, $00   ; Sprite Palette 1
  .byte $0F, $00, $00, $00   ; Sprite Palette 2
  .byte $0F, $00, $00, $00   ; Sprite Palette 3
