module MUX32
(
    Data_1_i,
    Data_2_i,
    Control_i,
    Data_o
);

input [31:0] Data_1_i;
input [31:0] Data_2_i;
input Control_i;

output [31:0] Data_o;

assign Data_o = Control_i ? Data_2_i : Data_1_i;

endmodule
