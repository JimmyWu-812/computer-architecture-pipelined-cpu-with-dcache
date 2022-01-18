CC = iverilog
NAME = CPU

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
