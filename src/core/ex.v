`include "../headers/buceros_header.v"

module ex (
    input  wire               wmem_en_i,
    input  wire               rmem_en_i,
    input  wire [ `OpcodeBus] opcode_i,
    input  wire [ `Funct3Bus] funct3_i,
    input  wire [ `Funct7Bus] funct7_i,
    input  wire [    `ImmBus] imm_i,
    input  wire               wreg_en_i,
    input  wire [`RegAddrBus] wreg_addr_i,
    input  wire [`RegDataBus] rs1_data_i,
    input  wire [`RegDataBus] rs2_data_i,

    output wire               wmem_en_o,
    output wire               rmem_en_o,
    output wire [`RomAddrBus] mem_addr_o,
    output wire [ `Funct3Bus] funct3_o,
    output wire               wreg_en_o,
    output wire [`RegAddrBus] wreg_addr_o,
    output wire [`RegDataBus] wreg_data_o
);

    reg  [`RegDataBus] wreg_data_r;

    wire [`RegDataBus] data2;           // the data to be in the arithmetic with immediate
    wire [        4:0] shift_num;
    wire               exe_sub;         // when valid, execute the operation SUB
    wire               exe_shift_arith; // when valid, execute the operation shift_arithmetic

    wire [`RegDataBus] result_sum;  // result of ADDI and ADD,SUB
    wire [`RegDataBus] result_sl;   // result of SLLI and SLL
    wire [`RegDataBus] result_slt;  // result of SLTI and SLT
    wire [`RegDataBus] result_sltu; // result of SLTIU and SLTU
    wire [`RegDataBus] result_xor;  // result of XORI and XOR
    wire [`RegDataBus] result_sr;   // result of SRLI,SRAI and SRL,SRA
    wire [`RegDataBus] result_or;   // result of ORI and OR
    wire [`RegDataBus] result_and;  // result of ANDI and AND

    assign wmem_en_o = wmem_en_i;
    assign rmem_en_o = rmem_en_i;
    assign mem_addr_o = rs1_data_i + imm_i;
    assign funct3_o = funct3_i;
    assign wreg_en_o = wreg_en_i;
    assign wreg_addr_o = wreg_addr_i;
    assign wreg_data_o = wreg_data_r;

    assign data2 = opcode_i[5] ? rs2_data_i : imm_i;
    assign shift_num = data2[4:0];
    assign exe_sub = funct7_i[5] & opcode_i[5];
    assign exe_shift_arith = funct7_i[5];

    assign result_sum  = rs1_data_i + (exe_sub ^ data2 + exe_sub);
    assign result_sl   = rs1_data_i << shift_num;
    assign result_slt  = rs1_data_i[`REG_DATA_W - 1] ^ data2[`REG_DATA_W - 1] ? rs1_data_i[`REG_DATA_W - 1] : rs1_data_i[`REG_DATA_W - 2:0] < data2[`REG_DATA_W - 2:0];
    assign result_sltu = rs1_data_i < data2;
    assign result_xor  = rs1_data_i ^ data2;
    assign result_sr   = (rs1_data_i >> shift_num) | ({`REG_DATA_W{exe_shift_arith & rs1_data_i[`REG_DATA_W - 1]}} << (`REG_DATA_W - shift_num));
    assign result_or   = rs1_data_i | data2;
    assign result_and  = rs1_data_i & data2;

    always @ (*) begin
        case (opcode_i)
            `INST_LUI: begin
                wreg_data_r = imm_i;
            end
            `INST_AUIPC: begin
                wreg_data_r = imm_i;
            end
            `INST_JAL: begin
                wreg_data_r = imm_i;
            end
            `INST_JALR: begin
                wreg_data_r = imm_i;
            end
            `INST_B_TYPE: begin
                wreg_data_r = `ZeroWord;
            end
            `INST_LOAD: begin
                wreg_data_r = `ZeroWord;
            end
            `INST_STORE: begin
                wreg_data_r = rs2_data_i; // if store, the data will be put in wreg_data!
            end
            `INST_ARITH_IMM: begin
                case (funct3_i)
                    `INST_SUM: begin
                        wreg_data_r = result_sum;
                    end
                    `INST_SL: begin
                        wreg_data_r = result_sl;
                    end
                    `INST_SLT: begin
                        wreg_data_r = result_slt;
                    end
                    `INST_SLTU: begin
                        wreg_data_r = result_sltu;
                    end
                    `INST_XOR: begin
                        wreg_data_r = result_xor;
                    end
                    `INST_SR: begin
                        wreg_data_r = result_sr;
                    end
                    `INST_OR: begin
                        wreg_data_r = result_or;
                    end
                    `INST_AND: begin
                        wreg_data_r = result_and;
                    end
                    default: begin
                        wreg_data_r = `ZeroWord;
                    end
                endcase
            end
            `INST_ARITH: begin
                case (funct3_i)
                    `INST_SUM: begin
                        wreg_data_r = result_sum;
                    end
                    `INST_SL: begin
                        wreg_data_r = result_sl;
                    end
                    `INST_SLT: begin
                        wreg_data_r = result_slt;
                    end
                    `INST_SLTU: begin
                        wreg_data_r = result_sltu;
                    end
                    `INST_XOR: begin
                        wreg_data_r = result_xor;
                    end
                    `INST_SR: begin
                        wreg_data_r = result_sr;
                    end
                    `INST_OR: begin
                        wreg_data_r = result_or;
                    end
                    `INST_AND: begin
                        wreg_data_r = result_and;
                    end
                    default: begin
                        wreg_data_r = `ZeroWord;
                    end
                endcase
            end
            `INST_FENCE: begin
                wreg_data_r = `ZeroWord; // not extended yet
            end
            `INST_ENV: begin
                wreg_data_r = `ZeroWord; // not extended yet
            end
            default: begin
                wreg_data_r = `ZeroWord;
            end
        endcase
    end

endmodule //ex
