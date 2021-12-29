module Hazard_Detection_Unit
(
    Read_Register_1_ID_i,
    Read_Register_2_ID_i,
    Write_Register_EX_i,
    MemRead_EX_i,
    NoOp_o,
    Stall_o,
    PCWrite_o
);

input MemRead_EX_i;
input [4:0] Read_Register_1_ID_i, Read_Register_2_ID_i, Write_Register_EX_i;

output NoOp_o, Stall_o, PCWrite_o;

assign Stall_o = MemRead_EX_i
             && ((Read_Register_1_ID_i === Write_Register_EX_i) 
             || (Read_Register_2_ID_i === Write_Register_EX_i));
assign NoOp_o = Stall_o;
assign PCWrite_o = !Stall_o;

endmodule