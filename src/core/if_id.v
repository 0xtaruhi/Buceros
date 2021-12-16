/*
 * Description  : 
 * Author       : Zhengyi Zhang
 * Date         : 2021-11-25 16:39:58
 * LastEditTime : 2021-12-16 15:26:03
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\core\if_id.v
 */
`include "../headers/buceros_header.v"

module if_id (
    input  wire                clk,
    input  wire                rst_n,
    input  wire                hold_i,
    input  wire                jmp_en_i,
    input  wire [`InstAddrBus] pc_i,
    input  wire [    `InstBus] inst_i,

    output reg  [`InstAddrBus] pc_o,
    output reg  [    `InstBus] inst_o
);

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            pc_o   <= `PC_RST_ADDR;
            inst_o <= `NOP;
        end else if(hold_i) begin
            pc_o   <= pc_o;
            inst_o <= inst_o;
        end else if(jmp_en_i) begin
            inst_o <= `NOP;
            pc_o   <= pc_o;
        end else begin
            pc_o   <= pc_i;
            inst_o <= inst_i;
        end
    end

endmodule //if_id