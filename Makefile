TARGET = demo.nes
SOURCES = main.asm init.asm palettes.asm background.asm joypad.asm alien.asm skeleton.asm
OBJECTS = $(SOURCES:.asm=.o)
CC = ca65
LD = ld65
EMU = fceux

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(LD) -o $(TARGET) -C nes.cfg $(OBJECTS) -m demo.map --dbgfile demo.dbg

%.o: %.asm
	$(CC) -g -o $@ $<

run: $(TARGET)
	$(EMU) $(TARGET)

clean:
	rm -f $(TARGET) $(OBJECTS) demo.map demo.dbg
