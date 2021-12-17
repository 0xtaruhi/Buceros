`include "../headers/buceros_header.v"

module gen_dffsr #(
    parameter WIDTH = 1,
    parameter RST_DATA = 0,
    parameter HOLD_DATA = 0
) (
    input  wire             clk,
    input  wire             rst_n,

    input  wire             hold_i,
    input  wire [WIDTH-1:0] data_i,
    
    output reg  [WIDTH-1:0] data_o
);

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            data_o <= RST_DATA;
        end else if(hold_i) begin
            data_o <= HOLD_DATA;
        end else begin
            data_o <= data_i;
        end
    end

endmodule //gen_dffsr