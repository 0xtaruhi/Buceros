/*
 * Description  : pc register
 * Author       : Zhengyi Zhang
 * Date         : 2021-11-25 16:39:51
 * LastEditTime : 2021-12-22 01:07:53
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\core\pc_reg.v
 */
`include "../headers/buceros_header.v"

module pc_reg (
    input  wire                clk,
    input  wire                rst_n,

    input  wire                jmp_en_i,
    input  wire [`InstAddrBus] jmp_addr_i,
    input  wire                hold_i,
    output reg  [`InstAddrBus] pc_o
);

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            pc_o <= `PC_RST_ADDR;
        end else if(hold_i) begin
            pc_o <= pc_o;
        end else if(jmp_en_i) begin
            pc_o <= jmp_addr_i;
        end else begin
            pc_o <= pc_o + 32'd4;
        end
    end

endmodule //pc_reg