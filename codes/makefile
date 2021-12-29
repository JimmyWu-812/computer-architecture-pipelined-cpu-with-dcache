# CC and CFLAGS are varilables
CC = iverilog
NAME = CPU
# CFLAGS = -c
# AR = ar
# ARFLAGS = rcv
# -c option ask g++ to compile the source files, but do not link.
# -g option is for debugging version
# -O2 option is for optimized version
# DBGFLAGS = -g -D_DEBUG_ON_
# OPTFLAGS = -O3

all: $(NAME).out sim
	@echo -n ""

$(NAME).out: *.v
	$(CC) -o $@ $^

sim:
	vvp $(NAME).out

wav:
	gtkwave $(NAME).vcd

clean:
	rm -rf *.out *.vcd *.txt
