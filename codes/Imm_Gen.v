module Imm_Gen
(
    Imm_i,
    Imm_o
);

input [31:0] Imm_i;

output [31:0] Imm_o;

wire [31:0] Imm_Addi_Srai_Lw_o, Imm_Sw_o, Imm_Beq_o;

assign Imm_Addi_Srai_Lw_o = {{20{Imm_i[31]}}, Imm_i[31:20]};
assign Imm_Sw_o = {{20{Imm_i[31]}}, Imm_i[31:25], Imm_i[11:7]};
assign Imm_Beq_o = {{20{Imm_i[31]}}, Imm_i[31], Imm_i[7], Imm_i[30:25], Imm_i[11:8]};
assign Imm_o = Imm_i[5] ? (Imm_i[13] ? Imm_Sw_o : Imm_Beq_o) : Imm_Addi_Srai_Lw_o;

endmodule
