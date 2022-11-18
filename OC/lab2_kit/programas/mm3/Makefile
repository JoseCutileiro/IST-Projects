TARGETS = mm3
PAPILIB_ALAMEDA=/usr/lib/x86_64-linux-gnu/libpapi.so
PAPILIB_TAGUS=/usr/local/lib/libpapi.so
CFLAGS=-O1

all: $(TARGETS)

mm3: mm3.c
ifeq ($(shell test -e $(PAPILIB_ALAMEDA) && echo -n yes),yes)
	$(CC) $(CFLAGS) mm3.c $(PAPILIB_ALAMEDA) -o mm3
else
	$(CC) $(CFLAGS) mm3.c $(PAPILIB_TAGUS) -o mm3
endif

clean:
	rm -f $(TARGETS) *.o *.stderr *.stdout core *~
