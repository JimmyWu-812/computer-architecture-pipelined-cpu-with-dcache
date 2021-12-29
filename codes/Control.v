module Control
(
    Op_i,
    NoOp_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    Branch_o
);

input NoOp_i;
input [6:0] Op_i;

output ALUSrc_o, RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, Branch_o;
output [1:0] ALUOp_o;

assign RegWrite_o = !NoOp_i && (            !Op_i[5] ||  Op_i[4]);
assign MemtoReg_o = !NoOp_i && (            !Op_i[5] && !Op_i[4]);
assign MemRead_o  = MemtoReg_o;
assign MemWrite_o = !NoOp_i && (!Op_i[6] &&  Op_i[5] && !Op_i[4]);
assign ALUOp_o    = NoOp_i ? 0 : Op_i[6:5];
assign ALUSrc_o   = !NoOp_i && (            !Op_i[5] || !Op_i[4]);
assign Branch_o   = !NoOp_i && ( Op_i[6]                        );

endmodule
