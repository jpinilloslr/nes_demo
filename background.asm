.include "nes.inc"
.include "scene.inc"

.export load_background

.segment "ZEROPAGE"
  background_ptr: .res 2

.segment "CODE"

.proc load_background
  lda PPU_STATUS         ; Reset PPU toggle
  lda #$20
  sta PPU_ADDR
  lda #$00
  sta PPU_ADDR           ; Set PPU address to Name Table 0

  
  lda #<scene_tilemap
  sta background_ptr
  lda #>scene_tilemap
  sta background_ptr + 1 ; Set up a pointer to the tilemap in RODATA

  ldx #04                ; Outer loop counter (4 pages of 256 bytes)
  ldy #00                ; Inner loop counter (256 bytes per page)

@loop:
  lda (background_ptr), y
  sta PPU_DATA
  iny
  bne @loop

  inc background_ptr + 1 ; Increment high byte of pointer to move to next page
  dex                    ; Decrement outer loop counter
  bne @loop              ; Continue outer loop until X wraps around to 0

  lda #0
  sta PPU_SCROLL
  sta PPU_SCROLL
  jmp load_attribute_table
.endproc

.proc load_attribute_table
  lda PPU_STATUS               ; Reset PPU latch

  lda #$23
  sta PPU_ADDR
  lda #$C0
  sta PPU_ADDR                 ; Set PPU address to Name Table 0
  
  lda #<scene_attribute_table
  sta background_ptr
  lda #>scene_attribute_table  ; Set up a pointer to the attribute_table in RODATA
  sta background_ptr+1

  ldy #$00
@loop:
  lda (background_ptr), y
  sta PPU_DATA
  iny
  cpy #54                      ; Check if we've written 64 bytes (size of the attribute table)
  bne @loop

  ; Reset scroll registers
  lda #0
  sta PPU_SCROLL
  sta PPU_SCROLL

  rts
.endproc
