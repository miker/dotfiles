CC := gcc
CFLAGS := -Wall -pedantic -O3
LDFLAGS :=

PROG := main
OBJS := main.o

all: $(PROG)

$(PROG): $(OBJS)
        $(CC) $(LDFLAGS) -o $@ $^

clean:
        rm -rf $(PROG) $(OBJS)

.PHONY: all clean

