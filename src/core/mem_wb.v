module mem_wb (
    input  wire               clk,
    input  wire               nrst,
    input  wire [`StallBus]   stall, 
    input  wire               mem_wreg_en_i,
    input  wire [`RegAddrBus] mem_wreg_addr_i,
    input  wire [`RegDataBus] mem_wreg_data_i,

    output wire               wreg_en_o,
    output wire [`RegAddrBus] wreg_addr_o,
    output wire [`RegDataBus] wreg_data_o,
);
    // this module's goal is to write back to the universal registers
    always @(posedge clk) begin
        if(nrst == `NrstEnable)begin
        wreg_en_o   <= `Disable;
        wreg_addr_o <= `Disable;
        wreg_data_o <= `Disable;
        end
        else if(stall == 1) begin
        wreg_en_o   <= `Disable;
        wreg_addr_o <= `Disable;
        wreg_data_o <= `Disable;
        end
        else begin
        wreg_en_o   <= mem_wreg_en_i;
        wreg_addr_o <= mem_wreg_addr_i;
        wreg_data_o <= mem_wreg_data_i;
        end
    end
endmodule