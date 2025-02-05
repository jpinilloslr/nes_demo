;; Character memory (Tile graphics in CHR-ROM)
.segment "CHARS"
  ; Sprite 0 Low plane
  .byte %00000000  
  .byte %00000000  
  .byte %00000000  
  .byte %00000000  
  .byte %00000000  
  .byte %00000000  
  .byte %00000000  
  .byte %00000000
  ; Sprite 0 High plane
  .byte %00000000  
  .byte %00000000  
  .byte %00000000  
  .byte %00000000  
  .byte %00000000  
  .byte %00000000  
  .byte %00000000  
  .byte %00000000  

  ; Sprite 1 Low plane
  .byte %00000000  
  .byte %00110100  
  .byte %01011010  
  .byte %01111110  
  .byte %01111110  
  .byte %00111100  
  .byte %00011000  
  .byte %00000000
  ; Sprite 1 High plane
  .byte %00000000  
  .byte %00110100  
  .byte %01011010
  .byte %10000001  
  .byte %10000001  
  .byte %10000001  
  .byte %00000000  
  .byte %00000000

  ; Sprite 2 Low plane
  .byte %00000000  
  .byte %00110100  
  .byte %01011010  
  .byte %01111110  
  .byte %01111110  
  .byte %00111100  
  .byte %00011000  
  .byte %00000000
  ; Sprite 2 High plane
  .byte %00000000  
  .byte %00110100  
  .byte %11011011
  .byte %10000001  
  .byte %10000001  
  .byte %00000000  
  .byte %00000000  
  .byte %00000000

  ; Sprite 3 Low plane
  .byte %11001100
  .byte %11001100
  .byte %00110011
  .byte %00110011
  .byte %11001100
  .byte %11001100
  .byte %00110011
  .byte %00110011
  ; Sprite 3 High plane
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000

