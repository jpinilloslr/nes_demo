.include "nes.inc"
.include "skeleton_anims.inc"
.include "joypad.inc"

.export skel_init
.export skel_update

.segment "ZEROPAGE"
  skel_pos_x:          .res 1
  skel_pos_y:          .res 1
  skel_timer:          .res 1
  skel_max_frames:     .res 1
  skel_anim_speed:     .res 1
  skel_cur_anim_id:    .res 1
  skel_cur_anim_ptr:   .res 2
  skel_cur_frame_ptr:  .res 2
  skel_cur_frame_idx:  .res 1
  skel_flip:           .res 1

.segment "CODE"

.proc skel_init
  ldx #200
  stx skel_pos_x
  ldx #150
  stx skel_pos_y
  lda #0
  sta skel_timer
  sta skel_max_frames
  sta skel_anim_speed
  sta skel_cur_frame_idx
  sta skel_cur_anim_ptr
  sta skel_cur_anim_ptr + 1
  sta skel_cur_frame_ptr
  sta skel_cur_frame_ptr + 1
  lda #$ff
  sta skel_cur_anim_id

  jmp skel_set_idle_anim
.endproc

.proc skel_update
  inc skel_timer
  jsr skel_check_joypad
  jsr skel_animate
  jsr skel_reset_attack
  jsr skel_draw
  rts
.endproc

.proc skel_draw
  lda #$04
  sta PPU_OAM_ADDR            ; Set OAM address to 0

; Load the address of the current frame
  ldy skel_cur_frame_idx      ; Use frame index for offset calculation
  tya                         ; Transfer Y to A
  asl A                       ; Multiply frame index by 2 (each pointer is 2 bytes)
  tay                         ; Transfer back to Y (Y now holds the proper offset)
  lda (skel_cur_anim_ptr), y  ; Load low byte from pointer table
  sta skel_cur_frame_ptr
  iny                         ; Increment Y to point to the high byte
  lda (skel_cur_anim_ptr), y  ; Load high byte
  sta skel_cur_frame_ptr + 1

  ldy #0                      ; Initialize index for frame data

@loop:
  ; Write Y position (skel_pos_y + relative Y from frame)
  lda (skel_cur_frame_ptr), y ; Load relative Y position
  clc
  adc skel_pos_y              ; Add skel_pos_y
  sta PPU_OAM_DATA            ; Write Y position to OAM
  iny                         ; Move to next byte in frame data

  ; Write Tile ID
  lda (skel_cur_frame_ptr), y ; Load Tile ID
  sta PPU_OAM_DATA            ; Write Tile ID to OAM
  iny                         ; Move to next byte in frame data

  ; Is it flipped?
  lda skel_flip
  cmp #1
  beq @flip

  ; Write Attributes
  lda (skel_cur_frame_ptr), y ; Load Attributes
  sta PPU_OAM_DATA            ; Write Attributes to OAM
  iny                         ; Move to next byte in frame data

  ; Write X position (skel_pos_x + relative X from frame)
  lda (skel_cur_frame_ptr), y ; Load relative X position
  clc
  adc skel_pos_x              ; Add skel_pos_x
  sta PPU_OAM_DATA            ; Write X position to OAM
  iny                         ; Move to next byte in frame data

  jmp @check_next_iter

  @flip:
  ; Write Attribute with horizontal flipping
  lda (skel_cur_frame_ptr), y ; Load Attributes
  ora #%01000000              ; Flip it
  sta PPU_OAM_DATA            ; Write Attributes to OAM
  iny                         ; Move to next byte in frame data

  ; Write X position flipped (skel_pos_x + relative X from frame)
  lda (skel_cur_frame_ptr), y ; Load relative X position
  eor #$ff                    ; A = bitwise NOT of x (~x)
  clc                         ; Clear carry for addition
  adc #25                     ; A = ~x + 25, which equals 24 - x modulo 256
  clc
  adc skel_pos_x              ; Add skel_pos_x
  sta PPU_OAM_DATA            ; Write X position to OAM
  iny                         ; Move to next byte in frame data

  @check_next_iter:
  cpy #48                     ; Check if 48 bytes have been written (12 sprites * 4 bytes)
  bne @loop                   ; If not, continue writing
  rts
.endproc

.proc skel_animate
  lda skel_timer
  cmp skel_anim_speed
  bne @no_update
  lda #0
  sta skel_timer
  lda skel_cur_frame_idx
  clc
  adc #1
  sta skel_cur_frame_idx
  cmp skel_max_frames
  bne @no_update
  lda #00
  sta skel_cur_frame_idx
@no_update:
  rts
.endproc

.proc skel_set_idle_anim
  lda skel_cur_anim_id
  cmp SkelIdleAnimId
  beq @do_nothing
  lda SkelIdleAnimFrames
  sta skel_max_frames
  lda SkelIdleAnimSpeed
  sta skel_anim_speed
  lda #<SkelIdleAnimPtr
  sta skel_cur_anim_ptr
  lda #>SkelIdleAnimPtr
  sta skel_cur_anim_ptr + 1
  lda #0
  sta skel_cur_frame_idx
  lda SkelIdleAnimId
  sta skel_cur_anim_id
  @do_nothing:
  rts
.endproc

.proc skel_set_walk_anim
  lda skel_cur_anim_id
  cmp SkelWalkAnimId
  beq @do_nothing
  lda SkelWalkAnimFrames
  sta skel_max_frames
  lda SkelWalkAnimSpeed
  sta skel_anim_speed
  lda #<SkelWalkAnimPtr
  sta skel_cur_anim_ptr
  lda #>SkelWalkAnimPtr
  sta skel_cur_anim_ptr + 1
  lda #0
  sta skel_cur_frame_idx
  lda SkelWalkAnimId
  sta skel_cur_anim_id
  @do_nothing:
  rts
.endproc

.proc skel_set_attack_anim
  lda skel_cur_anim_id
  cmp SkelAttackAnimId
  beq @do_nothing
  lda SkelAttackAnimFrames
  sta skel_max_frames
  lda SkelAttackAnimSpeed
  sta skel_anim_speed
  lda #<SkelAttackAnimPtr
  sta skel_cur_anim_ptr
  lda #>SkelAttackAnimPtr
  sta skel_cur_anim_ptr + 1
  lda #0
  sta skel_cur_frame_idx
  lda SkelAttackAnimId
  sta skel_cur_anim_id
  @do_nothing:
  rts
.endproc

.proc skel_reset_attack
  lda skel_cur_anim_id
  cmp SkelAttackAnimId
  bne @done
  lda skel_cur_frame_idx
  clc
  adc #1
  cmp skel_max_frames
  bne @done
  jmp skel_set_idle_anim
  @done:
  rts
.endproc

.proc skel_check_joypad
  lda skel_cur_anim_id
  cmp SkelAttackAnimId
  bne @check_controls
  rts

@check_controls:
  jsr joypad1_read       ; Read the joypad state
  lda joypad1_state      ; Load the joypad state
  and #BUTTON_A          ; Isolate A button bit
  bne @attack            ; If A button is pressed, attack
  lda joypad1_state      ; Load the joypad state
  and #BUTTON_LEFT       ; Isolate the left button bit
  bne @move_left         ; If the left button is pressed, move left
  lda joypad1_state      ; Load the joypad state
  and #BUTTON_RIGHT      ; Isolate the right button bit
  bne @move_right        ; If the right button is pressed, move right

  jmp skel_set_idle_anim ; Default to idle animation

@attack:
  jmp skel_set_attack_anim
@move_left:
  dec skel_pos_x
  lda #0
  sta skel_flip
  jmp skel_set_walk_anim
@move_right:
  inc skel_pos_x
  lda #1
  sta skel_flip
  jmp skel_set_walk_anim
.endproc
