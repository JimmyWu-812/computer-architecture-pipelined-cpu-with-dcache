module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i;
input    [24:0]    tag_i;
input    [255:0]   data_i;
input              enable_i;
input              write_i;

output   [24:0]    tag_o;
output   [255:0]   data_o;
output             hit_o;


// Memory
reg      [24:0]    tag [0:15][0:1];    
reg      [255:0]   data[0:15][0:1];

integer            i, j;


// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
            end
        end
    end
    if (enable_i && write_i) begin
        // TODO: Handle your write of 2-way associative cache + LRU here
        if (tag[addr_i][1][22:0] === tag_i[22:0] && tag[addr_i][1][24]) begin // write hit && tag matches MRU block(1)
            data[addr_i][1] <= data_i;
            tag[addr_i][1] <= tag_i;
        end
        else begin // (write hit && tag matches LRU block(0)) || (read miss [and read from memory])
            data[addr_i][0] <= data[addr_i][1];
            tag[addr_i][0] <= tag[addr_i][1];
            data[addr_i][1] <= data_i;
            tag[addr_i][1] <= tag_i;
        end
    end
end

// Read Data      
// TODO: tag_o=? data_o=? hit_o=?

// output replaced data to controller
assign tag_o = (tag[addr_i][1][22:0] === tag_i[22:0]/* && tag[addr_i][1][24]*/) ? tag[addr_i][1] : tag[addr_i][0];
assign data_o = (tag[addr_i][1][22:0] === tag_i[22:0]/* && tag[addr_i][1][24]*/) ? data[addr_i][1] : data[addr_i][0];

assign hit_o = (tag[addr_i][1][22:0] === tag_i[22:0] && tag[addr_i][1][24]) || (tag[addr_i][0][22:0] === tag_i[22:0] && tag[addr_i][0][24]);

endmodule
