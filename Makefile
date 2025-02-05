TARGET = demo.nes
SOURCES = main.asm init.asm palettes.asm alien.asm
OBJECTS = $(SOURCES:.asm=.o)
CC = ca65
LD = ld65
EMU = fceux

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(LD) -o $(TARGET) -C nes.cfg $(OBJECTS)

%.o: %.asm
	$(CC) -o $@ $<

run: $(TARGET)
	$(EMU) $(TARGET)

clean:
	rm -f $(TARGET) $(OBJECTS)
