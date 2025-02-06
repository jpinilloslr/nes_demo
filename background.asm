.include "nes.inc"

.export LoadBackground

.segment "CODE"

.proc LoadBackground
  lda PPU_STATUS         ; Reset PPU toggle (read PPU_STATUS)
  lda #$20               ; Set PPU address high byte ($2000 - Start of Name Table 0)
  sta PPU_ADDR
  lda #$00               ; Low byte (start at the beginning of the name table)
  sta PPU_ADDR

  ldx #$04               ; Outer loop counter (4 pages of 256 bytes)
  ldy #$00               ; Inner loop counter (256 bytes per page)
  lda #03                ; Tile index to fill the background with

@loop:
  sta PPU_DATA           ; Write tile to PPU
  dey                    ; Decrement inner loop counter
  bne @loop              ; Continue inner loop until Y wraps around to 0
  dex                    ; Decrement outer loop counter
  bne @loop              ; Continue outer loop until X wraps around to 0

  lda #0
  sta PPU_SCROLL         ; Reset horizontal scroll
  sta PPU_SCROLL         ; Reset vertical scroll
  jmp LoadAttributeTable ; Load the attribute table
.endproc

.proc LoadAttributeTable
  lda PPU_STATUS         ; Reset PPU latch

  lda #$23               ; Set PPU address to $23C0 (Start of Attribute Table)
  sta PPU_ADDR
  lda #$C0
  sta PPU_ADDR

  ldx #$00
@loop:
  lda #$00               ; Use Background Palette 0 for all 2x2 tile blocks
  sta PPU_DATA
  inx
  cpx #$40               ; 64 bytes for the full Attribute Table
  bne @loop

  lda #0
  sta PPU_SCROLL         ; Reset horizontal scroll
  sta PPU_SCROLL         ; Reset vertical scroll
  rts
.endproc
