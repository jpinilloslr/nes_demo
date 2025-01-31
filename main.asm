.segment "HEADER"
  .byte $4E, $45, $53, $1A  ; iNES header identifier "NES" + magic number
  .byte 2               ; 2x 16KB PRG-ROM (32KB total)
  .byte 1               ; 1x 8KB CHR-ROM
  .byte $01, $00        ; Mapper 0, Vertical mirroring

.segment "VECTORS"
  .addr nmi             ; NMI (VBlank interrupt) handler
  .addr reset           ; Reset vector (entry point)
  .addr 0               ; IRQ (not used)

.segment "ZEROPAGE"  ; Zero-page variables (fastest access)
  acc_x: .res 1        ; X velocity
  acc_y: .res 1        ; Y velocity
  pos_x: .res 1        ; X position of sprite
  pos_y: .res 1        ; Y position of sprite

; Required STARTUP section, even if empty
.segment "STARTUP"

.segment "CODE"

reset:
  sei        ; Disable IRQs
  cld        ; Disable decimal mode
  ldx #$40
  stx $4017  ; Disable APU frame IRQ
  ldx #$ff   ; Set up stack
  txs        ; Transfer X to stack pointer
  inx        ; Now X = 0
  stx $2000  ; Disable NMI
  stx $2001  ; Disable rendering
  stx $4010  ; Disable DMC IRQs (sound)

;; Wait for the first VBlank before proceeding
vblankwait1:
  bit $2002  ; Read PPU status
  bpl vblankwait1  ; Loop until VBlank occurs

;; Clear RAM (Zero memory)
clear_memory:
  lda #$00
  sta $0000, x
  sta $0100, x
  sta $0200, x
  sta $0300, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  inx
  bne clear_memory  ; Loop until X wraps to 0

;; Wait for second VBlank to ensure PPU is ready
vblankwait2:
  bit $2002
  bpl vblankwait2

main:
load_palettes:
  lda $2002       ; Reset PPU latch
  lda #$3f
  sta $2006       ; Set PPU address to $3F00 (palette memory)
  lda #$00
  sta $2006
  ldx #$00
@loop:
  lda palettes, x
  sta $2007       ; Write palette data to PPU
  inx
  cpx #$20        ; Load 32 bytes
  bne @loop

;; Initialize sprite position and velocity
initialization:
  ldx #$80
  stx pos_x      ; Set X position to 128
  ldx #$30
  stx pos_y      ; Set Y position to 48
  ldx #$01
  stx acc_x      ; Set initial X velocity
  stx acc_y      ; Set initial Y velocity

enable_rendering:
  lda #%10000000  ; Enable NMI (VBlank interrupt)
  sta $2000
  lda #%00010000  ; Enable sprites
  sta $2001

forever:
  jmp forever  ; Infinite loop (execution relies on NMI)

;; VBlank Interrupt (updates graphics each frame)
nmi:
  jsr move_sprite
  jsr draw_sprite
  rti

move_sprite:
  lda pos_x
  clc
  adc acc_x   ; pos_x += acc_x
  sta pos_x
  cmp #245
  bcs reverse_x_direction  ; Reverse if X >= 245
  cmp #10
  bcc reverse_x_direction  ; Reverse if X < 10

  lda pos_y
  clc
  adc acc_y   ; pos_y += acc_y
  sta pos_y
  cmp #218
  bcs reverse_y_direction  ; Reverse if Y >= 218
  cmp #10
  bcc reverse_y_direction  ; Reverse if Y < 10
  rts

reverse_x_direction:
  lda acc_x
  eor #$ff   ; Flip bits (negate value)
  clc
  adc #$01   ; Convert -1 to 1 or 1 to -1
  sta acc_x
  rts

reverse_y_direction:
  lda acc_y
  eor #$ff   ; Flip bits (negate value)
  clc
  adc #$01   ; Convert -1 to 1 or 1 to -1
  sta acc_y
  rts

draw_sprite:
  lda #$00 
  sta $2003      ; Set OAM address to 0

  lda pos_y
  sta $2004      ; Write Y position

  lda #$00 
  sta $2004      ; Tile ID (selects graphic)

  lda #$00 
  sta $2004      ; Attributes (palette, flipping)

  lda pos_x
  sta $2004      ; Write X position
  rts

palettes:
  ; Background Palette
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00

  ; Sprite Palette
  .byte $0f, $20, $00, $00
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00

;; Character memory (Tile graphics in CHR-ROM)
.segment "CHARS"
  .byte %00011000  ; Pixel data for a simple 8x8 sprite
  .byte %01111110
  .byte %11111111
  .byte %11111111
  .byte %11111111
  .byte %11111111
  .byte %01111110
  .byte %00011000
  .byte $00, $00, $00, $00, $00, $00, $00, $00  ; High plane (all black)
