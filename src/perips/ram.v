`include "buceros_header.v"
module ram (
    input                             clk,
    input                             rst_n,
    input [  `DataAddrBus]            addr_i,
    input                             wmen_en_i,
    input                             rmen_en_i,
    input [      `DataBus]            data_i,
    
    output[      `DataBus]            data_o
);
    reg [`RamBus] ram1 [`RamAddrBus];
    reg [`RamBus] ram2 [`RamAddrBus];
    reg [`RamBus] ram3 [`RamAddrBus];
    reg [`RamBus] ram4 [`RamAddrBus];
    // read
    assign data_o = (rmen_en_i) ? {ram1[{addr_i[31:2],11}],ram2[{addr_i[31:2],10}],ram3[addr_i[31:2],01],ram4[addr_i[31:2],00]} : 32'hzzzz;
    //write
    always @(posedge clk) begin
        if (ce) begin
            else if (we) begin
                ram1[addr_i[31:2],11] <= data_i[31:24];
                ram2[addr_i[31:2],10] <= data_i[23:16];
                ram3[addr_i[31:2],01] <= data_i[15:8];
                ram4[addr_i[31:2],00] <= data_i[7:0];
            end
            else begin
                ram1[addr_i[31:2],11] <= ram1[addr_i[31:2],11];
                ram2[addr_i[31:2],10] <= ram2[addr_i[31:2],10];
                ram3[addr_i[31:2],01] <= ram3[addr_i[31:2],01];
                ram4[addr_i[31:2],00] <= ram4[addr_i[31:2],00];
            end
        end
    end

endmodule