module ALU_Control
(
    Funct_i,
    ALUOp_i,
    ALUCtrl_o
);

input [1:0] ALUOp_i;
input [9:0] Funct_i;

output [2:0] ALUCtrl_o;

wire p1, p2, p3, p4, p5, p6, p7, p8, p9, p10;

assign p1 = !Funct_i[8] && !Funct_i[3] &&  Funct_i[2] && !Funct_i[1] && !Funct_i[0] && !ALUOp_i[1] &&  ALUOp_i[0];
assign p2 = !Funct_i[8] && !Funct_i[3] && !Funct_i[2] && !Funct_i[1] &&  Funct_i[0] && !ALUOp_i[1] &&  ALUOp_i[0];
assign p3 = !Funct_i[8] && !Funct_i[3] && !Funct_i[2] && !Funct_i[1] && !Funct_i[0] && !ALUOp_i[1] &&  ALUOp_i[0];
assign p4 =  Funct_i[8] && !Funct_i[3] && !Funct_i[2] && !Funct_i[1] && !Funct_i[0] && !ALUOp_i[1] &&  ALUOp_i[0];
assign p5 = !Funct_i[8] &&  Funct_i[3] && !Funct_i[2] && !Funct_i[1] && !Funct_i[0] && !ALUOp_i[1] &&  ALUOp_i[0];
assign p6 =                               !Funct_i[2] && !Funct_i[1] && !Funct_i[0] && !ALUOp_i[1] && !ALUOp_i[0];
assign p7 =  Funct_i[8] && !Funct_i[3] &&  Funct_i[2] && !Funct_i[1] &&  Funct_i[0] && !ALUOp_i[1] && !ALUOp_i[0];
assign p8 =                               !Funct_i[2] &&  Funct_i[1] && !Funct_i[0] && !ALUOp_i[1] && !ALUOp_i[0];
assign p9 =                               !Funct_i[2] &&  Funct_i[1] && !Funct_i[0] && !ALUOp_i[1] &&  ALUOp_i[0];
assign ALUCtrl_o[2] = p4 || p5 || p6 || p7;
assign ALUCtrl_o[1] = p2 || p3 || p6 || p7 || p8 || p9;
assign ALUCtrl_o[0] = p1 || p3 || p5 || p7 || p8 || p9;
endmodule
