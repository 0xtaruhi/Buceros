/*
 * Description  : ram
 * Author       : Zhengyi Zhang
 * Date         : 2021-12-12 00:37:22
 * LastEditTime : 2021-12-12 01:01:29
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\perips\ram.v
 */
`include "../headers/buceros_header.v"

module ram
#(parameter RAM_DEPTH = 16384,
  parameter RAM_DEPTH_BIT_LEN = 14)
(
    input  wire               clk,
    input  wire               rst_n,

    input  wire [`MemAddrBus] r_addr1_i,
    input  wire [`MemAddrBus] r_addr2_i,
    input  wire               w_en_i,
    input  wire [`MemAddrBus] w_addr_i,
    input  wire [   `WordBus] w_data_i, 
    input  wire [        3:0] w_sel_i,

    output wire [   `WordBus] r_data1_o,
    output wire [   `WordBus] r_data2_o
);

    reg  [`WordBus] _ram [0:RAM_DEPTH-1];
    wire [RAM_DEPTH_BIT_LEN-1:0] r_1_idx;
    wire [RAM_DEPTH_BIT_LEN-1:0] r_2_idx;
    wire [RAM_DEPTH_BIT_LEN-1:0] w_idx;
    integer i;
    
    assign r_1_idx = r_addr1_i[RAM_DEPTH_BIT_LEN+1:2];
    assign r_2_idx = r_addr2_i[RAM_DEPTH_BIT_LEN+1:2];
    assign w_idx   = w_addr_i[RAM_DEPTH_BIT_LEN+1:2];

    assign r_data1_o = rst_n ? _ram[r_1_idx] : `ZERO_WORD;
    assign r_data2_o = rst_n ? _ram[r_2_idx] : `ZERO_WORD;

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            for(i=0;i!=RAM_DEPTH;i=i+1) begin
                _ram[i] <= 0;
            end
        end else begin
            if(w_en_i) begin
                _ram[w_idx][31:24] <= w_sel_i[3] ? w_data_i[31:24] : _ram[w_idx][31:24];
                _ram[w_idx][23:16] <= w_sel_i[2] ? w_data_i[23:16] : _ram[w_idx][23:16];
                _ram[w_idx][15: 8] <= w_sel_i[1] ? w_data_i[15: 8] : _ram[w_idx][15: 8];
                _ram[w_idx][ 7: 0] <= w_sel_i[0] ? w_data_i[ 7: 0] : _ram[w_idx][ 7: 0];
            end else begin
                _ram[w_idx] <= _ram[w_idx];
            end
        end
    end

endmodule //ram
