TARGETS = file-sender file-receiver

CC = gcc
CFLAGS = -Wall -O0 -g
LD = gcc
LDFLAGS =

default: $(TARGETS) log-packets.so

file-sender: file-sender.o
file-receiver: file-receiver.o

$(TARGETS):
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) -MT $@ -MMD -MP -MF $@.d $(CFLAGS) -c -o $@ $<

%.so: %.c
	$(CC) -MT $@ -MMD -MP -MF $@.d -shared -fPIC $(CFLAGS) -o $@ $< -ldl

clean:
	rm -f $(TARGETS) *.so *.o *.d

-include $(wildcard *.d)
