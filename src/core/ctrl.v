`include "../headers/buceros_header.v"

module ctrl (
    input  wire rst_n,

    // input  wire stallreq_id_i,
    // input  wire stallreq_ex_i,
    // input  wire stallreq_mem_i,
    // input  wire stallreq_wb_i,
    input  wire stallreq_id_ex_i,
    input  wire enter_i,

    output wire [4:0] stall_o
);

    wire enter_n;

    assign enter_n = ~enter_i;
    // version 2.2 including stallreq from id_ex ONLY
    assign stall_o[0] = rst_n & enter_n & stallreq_id_ex_i; // to pc_reg
    assign stall_o[1] = rst_n & enter_n & stallreq_id_ex_i; // to if_id
    assign stall_o[2] = rst_n & enter_n & stallreq_id_ex_i; // to id_ex
    assign stall_o[3] = rst_n & enter_n & 1'b0;             // to ex_mem
    assign stall_o[4] = rst_n & enter_n & 1'b0;             // to mem_wb
    // assign stall_o[5] = stallreq_id_ex_i;   // to regfile

    // version 1.0
    // assign stall_o = 5'b0;

endmodule //ctrl