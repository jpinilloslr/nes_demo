.include "nes.inc"
.include "init.inc"
.include "palettes.inc"
.include "chars.inc"
.include "background.inc"
.include "alien.inc"

.segment "HEADER"
  .byte $4E, $45, $53, $1A  ; iNES header identifier "NES" + magic number
  .byte 2                   ; 2x 16KB PRG-ROM (32KB total)
  .byte 1                   ; 1x 8KB CHR-ROM
  .byte $01, $00            ; Mapper 0, Vertical mirroring

.segment "VECTORS"
  .addr nmi            ; NMI (VBlank interrupt) handler
  .addr reset          ; Reset vector (entry point)
  .addr 0              ; IRQ (not used)

; Required STARTUP section, even if empty
.segment "STARTUP"

.segment "CODE"

reset:
  sei                    ; Disable IRQs
  cld                    ; Disable decimal mode
  ldx #$40
  stx APU_FRAME_COUNTER  ; Disable APU frame IRQ
  ldx #$ff               ; Set up stack
  txs                    ; Transfer X to stack pointer
  inx                    ; Now X = 0
  stx PPU_CTRL           ; Disable NMI
  stx PPU_MASK           ; Disable rendering
  stx APU_DMC_CONTROL    ; Disable DMC IRQs (sound)
  jsr WaitForVBlank      ; Wait for VBlank to stabilize PPU
  jsr WaitForVBlank      ; Wait for VBlank a second time as it's more reliable
  jsr ClearRAM           ; Clear RAM (fill with zeros)

main:
  jsr LoadBackground
  jsr LoadPalettes
  jsr AlienInitialize
  jsr EnableRendering
  jsr GameLoop           ; Infinite loop as it relies on NMI

nmi:
  jsr AlienUpdate
  rti

