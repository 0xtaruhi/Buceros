`include "../headers/buceros_header.v"

module ctrl (
    input  wire rst_n,

    input  wire stallreq_id_i,
    input  wire stallreq_ex_i,
    input  wire stallreq_wb_i,
    input  wire enter_i,

    output wire [4:0] stall_o // stall[0] hold pc; stall[0:54] hold if,id,ex,mem,wb
);

    // reg [4:0] stall_r;

    // assign stall_o = stall_r;

    // always @ (*) begin
    //     stall_r = 5'b00000;
    // end

    assign stall_o = 5'b0;

endmodule //ctrl