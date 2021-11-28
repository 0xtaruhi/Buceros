
`include "buceros_header.v"
module rom (
    input                             clk,
    input                             rst_n,
    input [  `InstAddrBus]            InstBus_i,
    input                             winst_en_i,
    input                             rinst_en_i,
    input [      `DataBus]            inst_i,
    
    output[      `DataBus]            inst_o
);
    reg [`RomBus] rom1 [`RomAddrBus];
    reg [`RomBus] rom2 [`RomAddrBus];
    reg [`RomBus] rom3 [`RomAddrBus];
    reg [`RomBus] rom4 [`RomAddrBus];
    // read
    assign data_o = (rmen_en_i) ? {rom1[{inst_i[31:2],11}],rom2[{inst_i[31:2],10}],rom3[inst_i[31:2],01],rom4[inst_i[31:2],00]} : 32'hzzzz;
    //write
    always @(posedge clk) begin
        if (ce) begin
            else if (we) begin
                rom1[inst_i[31:2],11] <= inst_i[31:24];
                rom2[inst_i[31:2],10] <= inst_i[23:16];
                rom3[inst_i[31:2],01] <= inst_i[15:8];
                rom4[inst_i[31:2],00] <= inst_i[7:0];
            end
            else begin
                rom1[inst_i[31:2],11] <= rom1[inst_i[31:2],11];
                rom2[inst_i[31:2],10] <= rom2[inst_i[31:2],10];
                rom3[inst_i[31:2],01] <= rom3[inst_i[31:2],01];
                rom4[inst_i[31:2],00] <= rom4[inst_i[31:2],00];
            end
        end
    end

endmodule