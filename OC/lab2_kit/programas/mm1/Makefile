TARGETS = mm1
PAPILIB_ALAMEDA=/usr/lib/x86_64-linux-gnu/libpapi.so
PAPILIB_TAGUS=/usr/local/lib/libpapi.so
CFLAGS=-O1 -g -fsanitize=undefined

all: $(TARGETS)

mm1: mm1.c
ifeq ($(shell test -e $(PAPILIB_ALAMEDA) && echo -n yes),yes)
	$(CC) $(CFLAGS) mm1.c $(PAPILIB_ALAMEDA) -o mm1
else
	$(CC) $(CFLAGS) mm1.c $(PAPILIB_TAGUS) -o mm1
endif


clean:
	rm -f $(TARGETS) *.o *.stderr *.stdout core *~
