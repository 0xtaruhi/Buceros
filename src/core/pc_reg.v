/*
 * Description  : pc register
 * Author       : Zhengyi Zhang
 * Date         : 2021-11-25 16:39:51
 * LastEditTime : 2021-11-25 18:20:43
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\core\pc_reg.v
 */
`include "../headers/define.v"

module pc_reg (
    input  wire                clk,
    input  wire                rst_n,

    input  wire                jmp_en_i,
    input  wire [`InstAddrBus] jmp_addr_i,
    input  wire                hold_i,

    `ifdef JTAG_ENABLE
    input  wire                jtag_rst_en_i,
    `endif

    output reg  [`InstAddrBus] pc_o
);

    always @(posedge clk or negedge rst_n) begin
        `ifdef JTAG_ENABLE
        if(~rst_n | jtag_rst_en_i) begin
        `else
        if(~rst_n) begin
        `endif
            pc_o <= `PC_RST_ADDR;
        end else if(jmp_en_i) begin
            pc_o <= jmp_addr_i;
        end else if(hold_i) begin
            pc_o <= pc_o;
        end else begin
            pc_o <= pc_o + 32'd4;
        end
    end

endmodule //pc_reg