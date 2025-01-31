TARGET = demo.nes
SOURCE = main.asm
CC = cl65
EMU = fceux

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(CC) --verbose --target nes -o $(TARGET) $(SOURCE)

run: $(TARGET)
	$(EMU) $(TARGET)

clean:
	rm -f $(TARGET)
