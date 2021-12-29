module ALU
(
    Data_1_i,
    Data_2_i,
    ALUCtrl_i,
    Data_o,
);

input signed [31:0] Data_1_i;
input signed [31:0] Data_2_i;
input [2:0] ALUCtrl_i;

output reg [31:0] Data_o;

always @(*) begin
    case(ALUCtrl_i)
        3'b000: Data_o = Data_1_i & Data_2_i;       // AND
        3'b001: Data_o = Data_1_i ^ Data_2_i;       // XOR
        3'b010: Data_o = Data_1_i << Data_2_i;      // SLL
        3'b011: Data_o = Data_1_i + Data_2_i;       // ADD, LW, SW
        3'b100: Data_o = Data_1_i - Data_2_i;       // SUB
        3'b101: Data_o = Data_1_i * Data_2_i;       // MUL
        3'b110: Data_o = Data_1_i + Data_2_i;       // ADDI
        3'b111: Data_o = Data_1_i >>> Data_2_i[4:0];// SRAI
    endcase
end

endmodule
