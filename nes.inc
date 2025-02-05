.ifndef NES_INC
NES_INC = 1

; PPU (Picture Processing Unit) Registers
PPU_CTRL         = $2000  ; PPU Control Register: sets NMI, sprite/tile settings, etc.
PPU_MASK         = $2001  ; PPU Mask Register: controls rendering options.
PPU_STATUS       = $2002  ; PPU Status Register: read to check VBlank and reset latch.
PPU_OAM_ADDR     = $2003  ; OAM Address Register: sets starting address in OAM.
PPU_OAM_DATA     = $2004  ; OAM Data Register: read/write sprite data.
PPU_SCROLL       = $2005  ; PPU Scroll Register: sets scrolling.
PPU_ADDR         = $2006  ; PPU Address Register: sets the address for PPU data access.
PPU_DATA         = $2007  ; PPU Data Register: used to read/write PPU memory.
PPU_OAM_DMA      = $4014  ; OAM DMA Register: used to copy 256 bytes of data to OAM.

; APU (Audio Processing Unit) Registers
APU_DMC_CONTROL   = $4010  ; APU DMC Control Register: controls DMC IRQs and sample playback.
APU_FRAME_COUNTER = $4017  ; APU Frame Counter: used to generate frame IRQs.

.endif

