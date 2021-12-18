/*
 * Description  : ram
 * Author       : Zhengyi Zhang
 * Date         : 2021-12-12 00:37:22
 * LastEditTime : 2021-12-18 12:22:27
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\perips\ram.v
 */
`include "../headers/buceros_header.v"

module ram
#(parameter RAM_DEPTH = 4096,
  parameter RAM_DEPTH_BIT_LEN = 12)
(
    input  wire               clk,
    input  wire               rst_n,

    input  wire [`MemAddrBus] addr_i,
    input  wire               w_en_i,
    input  wire [   `WordBus] w_data_i, 
    input  wire [        3:0] w_sel_i,

    output wire [   `WordBus] r_data_o
);

    reg  [`WordBus] _ram [0:RAM_DEPTH-1];
    wire [RAM_DEPTH_BIT_LEN-1:0] idx;
    integer i;
    
    assign idx = addr_i[RAM_DEPTH_BIT_LEN+1:2];
    assign r_data_o = rst_n ? _ram[idx] : `ZERO_WORD;

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            for(i=0;i!=RAM_DEPTH;i=i+1) begin
                _ram[i] <= 0;
            end
        end else begin
            if(w_en_i) begin
                _ram[idx][31:24] <= w_sel_i[3] ? w_data_i[31:24] : _ram[idx][31:24];
                _ram[idx][23:16] <= w_sel_i[2] ? w_data_i[23:16] : _ram[idx][23:16];
                _ram[idx][15: 8] <= w_sel_i[1] ? w_data_i[15: 8] : _ram[idx][15: 8];
                _ram[idx][ 7: 0] <= w_sel_i[0] ? w_data_i[ 7: 0] : _ram[idx][ 7: 0];
            end else begin
                _ram[idx] <= _ram[idx];
            end
        end
    end

endmodule //ram
