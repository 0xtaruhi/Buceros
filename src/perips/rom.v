/*
 * Description  : 
 * Author       : Zhengyi Zhang
 * Date         : 2021-12-12 00:37:22
 * LastEditTime : 2021-12-12 01:25:09
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\perips\rom.v
 */
`include "../headers/buceros_header.v"
module rom
#(parameter ROM_DEPTH = 16384,
  parameter ROM_DEPTH_BIT_LEN = 14)
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

    reg  [`WordBus] _rom [0:ROM_DEPTH-1];
    wire [ROM_DEPTH_BIT_LEN-1:0] r_1_idx;
    wire [ROM_DEPTH_BIT_LEN-1:0] r_2_idx;
    wire [ROM_DEPTH_BIT_LEN-1:0] w_idx;
    integer i;
    
    assign r_1_idx = r_addr1_i[ROM_DEPTH_BIT_LEN+1:2];
    assign r_2_idx = r_addr2_i[ROM_DEPTH_BIT_LEN+1:2];
    assign w_idx   = w_addr_i[ROM_DEPTH_BIT_LEN+1:2];

    assign r_data1_o = rst_n ? _rom[r_1_idx] : `ZeroWord;
    assign r_data2_o = rst_n ? _rom[r_2_idx] : `ZeroWord;

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            for(i=0;i!=ROM_DEPTH;i=i+1) begin
                _rom[i] <= 0;
            end
        end else begin
            if(w_en_i) begin
                _rom[w_idx][31:24] <= w_sel_i[3] ? w_data_i[31:24] : _rom[w_idx][31:24];
                _rom[w_idx][23:16] <= w_sel_i[2] ? w_data_i[23:16] : _rom[w_idx][23:16];
                _rom[w_idx][15: 8] <= w_sel_i[1] ? w_data_i[15: 8] : _rom[w_idx][15: 8];
                _rom[w_idx][ 7: 0] <= w_sel_i[0] ? w_data_i[ 7: 0] : _rom[w_idx][ 7: 0];
            end else begin
                _rom[w_idx] <= _rom[w_idx];
            end
        end
    end

endmodule //rom