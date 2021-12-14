`include "../headers/buceros_header.v"

module mem_wb (
    input  wire               clk,
    input  wire               rst_n,
    input  wire               hold_i,

    input  wire               mem_wreg_en_i,
    input  wire [`RegAddrBus] mem_wreg_addr_i,
    input  wire [`RegDataBus] mem_wreg_data_i,

    output wire               wb_wreg_en_o,
    output wire [`RegAddrBus] wb_wreg_addr_o,
    output wire [`RegDataBus] wb_wreg_data_o
);

    gen_dffr #(.WIDTH(       1'b1)) dffr_wreg_en  (clk, rst_n, hold_i, mem_wreg_en_i, wb_wreg_en_o);
    gen_dffr #(.WIDTH(`REG_ADDR_W)) dffr_wreg_addr(clk, rst_n, hold_i, mem_wreg_addr_i, wb_wreg_addr_o);
    gen_dffr #(.WIDTH(`REG_DATA_W)) dffr_wreg_data(clk, rst_n, hold_i, mem_wreg_data_i, wb_wreg_data_o);

endmodule //mem_wb