/*
 * Description  : Asynchronous Reset D-Flip-Flop with reset value 0
 * Author       : Zhengyi Zhang
 * Date         : 2021-11-25 16:58:54
 * LastEditTime : 2021-11-25 17:06:27
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\utils\gen_dffr.v
 */

module gen_dffr #(
    parameter WIDTH = 1
) (
    input  wire             clk,
    input  wire             rst_n,

    input  wire             hold_i,
    input  wire [WIDTH-1:0] data_i,
    
    output reg  [WIDTH-1:0] data_o
);

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            data_o <= 0;
        end else if(hold_i) begin
            data_o <= data_o;
        end else begin
            data_o <= data_i;
        end
    end

endmodule //gen_dffr