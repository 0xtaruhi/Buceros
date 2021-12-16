`include "../headers/buceros_header.v"

module mem (
    input  wire               wmem_en_i,
    input  wire               rmem_en_i,
    input  wire [`MemAddrBus] mem_addr_i,
    input  wire [   `WordBus] rmem_data_i,   // data from RAM IF LOAD
    input  wire [ `Funct3Bus] funct3_i,
    input  wire               wreg_en_i,
    input  wire [`RegAddrBus] wreg_addr_i,
    input  wire [`RegDataBus] wreg_data_i,  // IF STORE, the data(to be put in RAM) will be put here

    output wire               wmem_en_o,
    output wire               rmem_en_o,
    output wire [`MemAddrBus] mem_addr_o,
    output wire [   `WordBus] wmem_data_o,
    output wire               wreg_en_o,
    output wire [`RegAddrBus] wreg_addr_o,
    output wire [`RegDataBus] wreg_data_o
);

    reg  [   `WordBus] wmem_data_r;
    reg  [`RegDataBus] wreg_data_r;
    
    assign wmem_en_o = wmem_en_i;
    assign rmem_en_o = rmem_en_i;
    assign mem_addr_o = mem_addr_i;
    assign wmem_data_o = wmem_data_r;
    assign wreg_en_o = wreg_en_i;
    assign wreg_addr_o = wreg_addr_i;
    assign wreg_data_o = wreg_data_r;

    always @ (*) begin
        if (wmem_en_i) begin
            case (funct3_i)
                `INST_BYTE: begin
                    wmem_data_r = {{(`ROM_WIDTH - `BYTE_WIDTH){1'b0}},wreg_data_i[`BYTE_WIDTH - 1:0]};
                end
                `INST_HALF_WORD: begin
                    wmem_data_r = {{(`ROM_WIDTH - `HALF_WORD_WIDTH){1'b0}},wreg_data_i[`HALF_WORD_WIDTH - 1:0]};
                end
                `INST_WORD: begin
                    wmem_data_r = wreg_data_i; // not extended to ARCH_RV64, so the code has been simplified
                end
                default: begin
                    wmem_data_r = `ZERO_WORD;
                end
            endcase
            wreg_data_r = `ZERO_WORD; // when store, do nothing with wreg_data
        end else if (rmem_en_i) begin
            wmem_data_r = `ZERO_WORD; // when load, do nothing with mem_data
            case (funct3_i)
                `INST_BYTE: begin
                    wreg_data_r = {{(`ROM_WIDTH - `BYTE_WIDTH){rmem_data_i[`BYTE_WIDTH - 1]}},rmem_data_i[`BYTE_WIDTH - 1:0]};
                end
                `INST_HALF_WORD: begin
                    wreg_data_r = {{(`ROM_WIDTH - `HALF_WORD_WIDTH){rmem_data_i[`HALF_WORD_WIDTH - 1]}},rmem_data_i[`HALF_WORD_WIDTH - 1]};
                end
                `INST_WORD: begin
                    wreg_data_r = rmem_data_i; // not extended to ARCH_RV64, so the code has been simplified
                end
                `INST_BYTE_U: begin
                    wreg_data_r = {{(`ROM_WIDTH - `BYTE_WIDTH){1'b0}},rmem_data_i[`BYTE_WIDTH - 1:0]};
                end
                `INST_HALF_WORD_U: begin
                    wreg_data_r = {{(`ROM_WIDTH - `HALF_WORD_WIDTH){1'b0}},rmem_data_i[`HALF_WORD_WIDTH - 1]};
                end
                default: begin
                    wreg_data_r = `ZERO_WORD;
                end
            endcase
        end else begin
            wmem_data_r = `ZERO_WORD;
            wreg_data_r = wreg_data_i;
        end
    end

endmodule //mem
