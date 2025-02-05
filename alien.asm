.include "nes.inc"

.export AlienInitialize
.export AlienUpdate

.segment "ZEROPAGE"
  alien_acc_x:      .res 1
  alien_acc_y:      .res 1
  alien_pos_x:      .res 1
  alien_pos_y:      .res 1
  alien_frame:      .res 1
  alien_anim_timer: .res 1

.segment "CODE"

.proc AlienInitialize
  ldx #$80
  stx alien_pos_x      ; Set X alien_position to 128
  ldx #$30
  stx alien_pos_y      ; Set Y position to 48
  ldx #$01
  stx alien_acc_x      ; Set initial X velocity
  stx alien_acc_y      ; Set initial Y velocity
  ldx #$00
  stx alien_frame      ; Set initial animation frame
  rts
.endproc

.proc AlienUpdate
  jsr AlienAnimate
  jsr AlienMove
  jsr AlienDraw
  rts
.endproc

.proc AlienDraw
  lda #$00 
  sta PPU_OAM_ADDR      ; Set OAM address to 0
  lda alien_pos_y
  sta PPU_OAM_DATA      ; Write Y position
  lda alien_frame
  sta PPU_OAM_DATA      ; Tile ID (selects graphic)
  lda #$00 
  sta PPU_OAM_DATA      ; Attributes (palette, flipping)
  lda alien_pos_x
  sta PPU_OAM_DATA      ; Write X position
  rts
.endproc

.proc AlienAnimate
  lda alien_anim_timer  ; Load animation timer
  clc                   ; Clear carry to ensure clean addition
  adc #1                ; Increment timer by 1
  sta alien_anim_timer  ; Store updated timer
  and #$0F              ; Update every 16 frames
  bne @no_update        ; If not 0, skip frame update
  lda alien_frame       ; Load current animation frame
  clc                   ; Clear carry
  adc #1                ; Increment frame by 1
  and #$01              ; Limit frame to 0 or 1
  sta alien_frame       ; Store updated frame
  lda #0                ; Reset animation timer
  sta alien_anim_timer  
@no_update:
  rts
.endproc

.proc AlienMove
  lda alien_pos_x
  clc
  adc alien_acc_x        ; alien_pos_x += alien_acc_x
  sta alien_pos_x
  cmp #245
  bcs ReverseXDirection  ; Reverse if X >= 245
  cmp #0
  bcc ReverseXDirection  ; Reverse if X < 10

  lda alien_pos_y
  clc
  adc alien_acc_y        ; alien_pos_y += alien_acc_y
  sta alien_pos_y
  cmp #218
  bcs ReverseYDirection  ; Reverse if Y >= 218
  cmp #0
  bcc ReverseYDirection  ; Reverse if Y < 10
  rts
.endproc

.proc ReverseXDirection
  lda alien_acc_x
  eor #$ff               ; Flip bits (negate value)
  clc
  adc #$01               ; Convert -1 to 1 or 1 to -1
  sta alien_acc_x
  rts
.endproc

.proc ReverseYDirection
  lda alien_acc_y
  eor #$ff
  clc
  adc #$01
  sta alien_acc_y
  rts
.endproc

