.ifndef SKEL_ANIM_INC
.define SKEL_ANIM_INC

.segment "RODATA"

;; Skeleton idle animation
SkelIdleAnimSpeed:  .byte 16
SkelIdleAnimFrames: .byte 4
SkelIdleAnimPtr:
  .word SkelIdleFrame0, SkelIdleFrame1, SkelIdleFrame2, SkelIdleFrame3
SkelIdleFrame0:
  .byte  0,  5, 1,  0  ; (0, 0)
  .byte  0,  6, 1,  8  ; (8, 0)
  .byte  0,  7, 1, 16  ; (16, 0)
  .byte  0,  0, 1, 24  ; (24, 0)
  .byte  8,  8, 1,  0  ; (0, 8)
  .byte  8,  9, 1,  8  ; (8, 8)
  .byte  8, 10, 1, 16  ; (16, 8)
  .byte  8, 11, 1, 24  ; (24, 8)
  .byte 16, 12, 1,  0  ; (0, 16)
  .byte 16, 13, 1,  8  ; (8, 16)
  .byte 16, 14, 1, 16  ; (16, 16)
  .byte 16, 15, 1, 24  ; (24, 16)
SkelIdleFrame1:
  .byte  0, 16, 1,  0  ; (0, 0)
  .byte  0, 17, 1,  8  ; (8, 0)
  .byte  0, 18, 1, 16  ; (16, 0)
  .byte  0,  0, 1, 24  ; (24, 0)
  .byte  8, 19, 1,  0  ; (0, 8)
  .byte  8, 20, 1,  8  ; (8, 8)
  .byte  8, 21, 1, 16  ; (16, 8)
  .byte  8, 22, 1, 24  ; (24, 8)
  .byte 16, 23, 1,  0  ; (0, 16)
  .byte 16, 24, 1,  8  ; (8, 16)
  .byte 16, 25, 1, 16  ; (16, 16)
  .byte 16, 26, 1, 24  ; (24, 16)
SkelIdleFrame2:
  .byte  0, 27, 1,  0  ; (0, 0)
  .byte  0, 17, 1,  8  ; (8, 0)
  .byte  0, 18, 1, 16  ; (16, 0)
  .byte  0,  0, 1, 24  ; (24, 0)
  .byte  8, 28, 1,  0  ; (0, 8)
  .byte  8, 29, 1,  8  ; (8, 8)
  .byte  8, 30, 1, 16  ; (16, 8)
  .byte  8, 31, 1, 24  ; (24, 8)
  .byte 16, 32, 1,  0  ; (0, 16)
  .byte 16, 33, 1,  8  ; (8, 16)
  .byte 16, 34, 1, 16  ; (16, 16)
  .byte 16, 35, 1, 24  ; (24, 16)
SkelIdleFrame3:
  .byte  0, 36, 1,  0  ; (0, 0)
  .byte  0, 37, 1,  8  ; (8, 0)
  .byte  0, 38, 1, 16  ; (16, 0)
  .byte  0,  0, 1, 24  ; (24, 0)
  .byte  8, 39, 1,  0  ; (0, 8)
  .byte  8, 40, 1,  8  ; (8, 8)
  .byte  8, 41, 1, 16  ; (16, 8)
  .byte  8, 42, 1, 24  ; (24, 8)
  .byte 16, 43, 1,  0  ; (0, 16)
  .byte 16, 44, 1,  8  ; (8, 16)
  .byte 16, 45, 1, 16  ; (16, 16)
  .byte 16, 46, 1, 24  ; (24, 16)

.endif

