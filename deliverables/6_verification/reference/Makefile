CC = gcc
SRCS = main.c test_vectors.c xxhash32-ref.c

.PHONY: all clean run debug

all: clean main

main: clean $(SRCS)
	$(CC) $(SRCS) -o main

debug: clean
	$(CC) -DXXH_DEBUG_PRINT $(SRCS) -o main

run: all
	@./main

clean:
	@rm -f main
