CROSS_COMPILE ?= aarch64-linux-gnu-

CC=$(CROSS_COMPILE)gcc
LD=$(CROSS_COMPILE)ld
OBJCOPY=$(CROSS_COMPILE)objcopy
OBJDUMP=$(CROSS_COMPILE)objdump
CFLAGS := -march=armv8-a

all: bl1.bin

bl1.bin: bl1.elf
	$(OBJCOPY) -O binary $< $@
	${OBJDUMP} -D -m arm $< > bl1.dis
	@cp $@ ../bin/$@

bl1.elf: bl1_entrypoint.o bl1.lds
	$(LD) -Bstatic -Tbl1.lds bl1_entrypoint.o -o $@

bl1_entrypoint.o: bl1_entrypoint.S
	$(CC) -c -o $@ $< $(CFLAGS)

bl1.lds: bl1.ld.in
	$(CPP) -P -o $@ - < $< $(CFLAGS)

clean:
	@rm -f *.o bl1.lds bl1.elf bl1.bin bl1.dis
