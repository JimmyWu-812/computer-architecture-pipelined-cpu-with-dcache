module Forwarding_Unit
(
    Read_Register_1_EX_i,
    Read_Register_2_EX_i,
    Write_Register_MEM_i,
    RegWrite_MEM_i,
    Write_Register_WB_i,
    RegWrite_WB_i,
    Forward_A_o,
    Forward_B_o
);

input [4:0] Read_Register_1_EX_i, Read_Register_2_EX_i, Write_Register_MEM_i, Write_Register_WB_i;
input RegWrite_MEM_i, RegWrite_WB_i;

output [1:0] Forward_A_o, Forward_B_o;

assign Forward_A_o[1] = RegWrite_MEM_i && (Write_Register_MEM_i !== 0)
             && (Read_Register_1_EX_i === Write_Register_MEM_i);
assign Forward_A_o[0] = RegWrite_WB_i && (Write_Register_WB_i !== 0)
             && (Read_Register_1_EX_i === Write_Register_WB_i);
assign Forward_B_o[1] = RegWrite_MEM_i && (Write_Register_MEM_i !== 0)
             && (Read_Register_2_EX_i === Write_Register_MEM_i);
assign Forward_B_o[0] = RegWrite_WB_i && (Write_Register_WB_i !== 0)
             && (Read_Register_2_EX_i === Write_Register_WB_i);

endmodule