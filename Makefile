CROSS_COMPILE ?= arm-linux-gnueabi-

CC=$(CROSS_COMPILE)gcc
LD=$(CROSS_COMPILE)ld
OBJCOPY=$(CROSS_COMPILE)objcopy
OBJDUMP=$(CROSS_COMPILE)objdump
CFLAGS := -march=armv7-a

# Use build date/time and Git commit id to form a version message
VDATE=$(shell date '+%Y/%m/%d %H:%M:%S%z')
VCOMMIT=$(shell git rev-parse --verify --short HEAD 2>/dev/null)
VERSION_MSG='"LOADER:  Built $(VDATE) Commit-id $(VCOMMIT)"'


all: fastboot.bin

fastboot.bin: l-loader.elf
	$(OBJCOPY) -O binary $< $@
	${OBJDUMP} -D -m arm $< > l-loader.dis

l-loader.elf: start.o debug.o l-loader.lds
	$(LD) -Bstatic -Tl-loader.lds start.o debug.o -o $@

start.o: start.S bl1.bin
	$(CC) -c -o $@ $< -DVERSION_MSG=$(VERSION_MSG) $(CFLAGS)

debug.o: debug.S
	$(CC) -c -o $@ $< $(CFLAGS)


l-loader.lds: l-loader.ld.in
	$(CPP) -P -o $@ - < $< $(CFLAGS)

bl1.bin:
	@cd ./aarch64 && $(MAKE)

clean:
	@cd ./aarch64 && $(MAKE) clean
	@rm -f *.o l-loader.lds l-loader.elf fastboot.bin l-loader.dis bin/bl1.bin
