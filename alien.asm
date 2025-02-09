.include "nes.inc"

.export alien_init
.export alien_update

.segment "ZEROPAGE"
  alien_acc_x:      .res 1
  alien_acc_y:      .res 1
  alien_pos_x:      .res 1
  alien_pos_y:      .res 1
  alien_frame:      .res 1
  alien_anim_timer: .res 1

.segment "CODE"

.proc alien_init
  ldx #10
  stx alien_pos_x      ; Set X alien_position to 10
  ldx #20
  stx alien_pos_y      ; Set Y position to 20
  ldx #01
  stx alien_acc_x      ; Set initial X velocity
  stx alien_acc_y      ; Set initial Y velocity
  ldx #00
  stx alien_frame      ; Set initial animation frame
  rts
.endproc

.proc alien_update
  jsr alien_animate
  jsr alien_move
  jsr alien_draw
  rts
.endproc

.proc alien_draw
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

.proc alien_animate
  lda alien_anim_timer  ; Load animation timer
  clc                   ; Clear carry
  adc #1                ; Increment timer
  sta alien_anim_timer  ; Store updated timer
  and #$0F              ; Update every 16 frames
  bne @no_update        ; If not 0, skip frame update
  lda alien_frame       ; Load current frame
  clc
  adc #1
  sta alien_frame
  cmp #4
  bne @no_update
  lda #$01
  sta alien_frame
@no_update:
  rts
.endproc

.proc alien_move
  lda alien_pos_x
  clc
  adc alien_acc_x        ; alien_pos_x += alien_acc_x
  sta alien_pos_x
  cmp #248
  bcs reverse_x_dir  ; Reverse if X >= 248
  cmp #0
  bcc reverse_x_dir  ; Reverse if X < 0

  lda alien_pos_y
  clc
  adc alien_acc_y        ; alien_pos_y += alien_acc_y
  sta alien_pos_y
  cmp #184
  bcs reverse_y_dir  ; Reverse if Y >= 168
  cmp #8
  bcc reverse_y_dir  ; Reverse if Y < 8
  rts
.endproc

.proc reverse_x_dir
  lda alien_acc_x
  eor #$ff               ; Flip bits (negate value)
  clc
  adc #$01               ; Convert -1 to 1 or 1 to -1
  sta alien_acc_x
  rts
.endproc

.proc reverse_y_dir
  lda alien_acc_y
  eor #$ff
  clc
  adc #$01
  sta alien_acc_y
  rts
.endproc

