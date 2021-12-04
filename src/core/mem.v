`include "../headers/buceros_header.v"

module mem (
    input  wire               wmem_en_i,
    input  wire               rmem_en_i,
    input  wire [`RomAddrBus] mem_addr_i,
    input  wire [    `RomBus] mem_data_i,   // data from RAM IF LOAD
    input  wire [ `Funct3Bus] funct3_i,
    input  wire               wreg_en_i,
    input  wire [`RegAddrBus] wreg_addr_i,
    input  wire [`RegDataBus] wreg_data_i,  // IF STORE, the data(to be put in RAM) will be put here

    output wire               wmem_en_o,
    output wire               rmem_en_o,
    output wire [    `RomBus] mem_data_o,
    output wire               wreg_en_o,
    output wire [`RegAddrBus] wreg_addr_o,
    output wire [`RegDataBus] wreg_data_o
);

    reg  [    `RomBus] mem_data_r;
    reg  [`RegDataBus] wreg_data_r;
    
    assign wmem_en_o = wmem_en_i;
    assign rmem_en_o = rmem_en_i;
    assign mem_data_o = mem_data_r;
    assign wreg_en_o = wreg_en_i;
    assign wreg_addr_o = wreg_addr_i;
    assign wreg_data_o = wreg_data_r;

    always @ (*) begin
        if (wmem_en_i) begin
            case (funct3_i)
                `INST_BYTE: begin
                    mem_data_r = {{(`ROM_WIDTH - `BYTE_WIDTH){1'b0}},wreg_data_i[`BYTE_WIDTH - 1:0]};
                end
                `INST_HALF_WORD: begin
                    mem_data_r = {{(`ROM_WIDTH - `HALF_WORD_WIDTH){1'b0}},wreg_data_i[`HALF_WORD_WIDTH - 1:0]};
                end
                `INST_WORD: begin
                    mem_data_r = wreg_data_i; // not extended to ARCH_RV64, so the code has been simplified
                end
                default: begin
                    mem_data_r = `ZeroWord;
                end
            endcase
            wreg_data_r = `ZeroWord; // when store, do nothing with wreg_data
        end else if (rmem_en_i) begin
            mem_data_r = `ZeroWord; // when load, do nothing with mem_data
            case (funct3_i)
                `INST_BYTE: begin
                    wreg_data_r = {{(`ROM_WIDTH - `BYTE_WIDTH){mem_data_i[`BYTE_WIDTH - 1]}},mem_data_i[`BYTE_WIDTH - 1:0]};
                end
                `INST_HALF_WORD: begin
                    wreg_data_r = {{(`ROM_WIDTH - `HALF_WORD_WIDTH){mem_data_i[`HALF_WORD_WIDTH - 1]}},mem_data_i[`HALF_WORD_WIDTH - 1]};
                end
                `INST_WORD: begin
                    wreg_data_r = mem_data_i; // not extended to ARCH_RV64, so the code has been simplified
                end
                `INST_BYTE_U: begin
                    wreg_data_r = {{(`ROM_WIDTH - `BYTE_WIDTH){1'b0}},mem_data_i[`BYTE_WIDTH - 1:0]};
                end
                `INST_HALF_WORD_U: begin
                    wreg_data_r = {{(`ROM_WIDTH - `HALF_WORD_WIDTH){1'b0}},mem_data_i[`HALF_WORD_WIDTH - 1]};
                end
                default: begin
                    wreg_data_r = `ZeroWord;
                end
            endcase
        end else begin
            mem_data_r = `ZeroWord;
            wreg_data_r = wreg_data_i;
        end
    end

endmodule //mem
