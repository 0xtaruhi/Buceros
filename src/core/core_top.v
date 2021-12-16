`include "../headers/buceros_header.v"

module core_top (
        input  wire               clk,
        input  wire               rst_n,
        input  wire               io_enter,

        input  wire [   `WordBus] inst_i,
        input  wire [   `WordBus] rmem_data_i,

        output wire               wmem_en_o,    // write RAM
        output wire               rmem_en_o,    // read RAM
        output wire [   `WordBus] wmem_data_o,   // data to be put in RAM
        output wire [`MemAddrBus] rom_addr_o,   // special for ROM
        output wire [`MemAddrBus] mem_addr_o    // for RAM, UART, GPIO
        //*** not completed yet
    );
    // among pc_reg, ROM(not in core) and if_id
    wire [`InstAddrBus] pc;

    // from if_id to id
    wire [`InstAddrBus] id_pc_i;
    wire [    `InstBus] id_inst_i;

    // from id to id_ex
    wire [`InstAddrBus] id_pc2ex_o;
    wire                id_wmem_en_o;
    wire                id_rmem_en_o;
    wire [  `OpcodeBus] id_opcode_o;
    wire [  `Funct3Bus] id_funct3_o;
    wire [  `Funct7Bus] id_funct7_o;
    wire [     `ImmBus] id_imm_o;
    wire                id_wreg_en_o;
    wire [ `RegAddrBus] id_wreg_addr_o;
    wire [ `RegDataBus] id_rs1_data_o;
    wire [ `RegDataBus] id_rs2_data_o;

    // from id_ex to ex
    wire [`InstAddrBus] ex_pc_i;
    wire                ex_wmem_en_i;
    wire                ex_rmem_en_i;
    wire [  `OpcodeBus] ex_opcode_i;
    wire [  `Funct3Bus] ex_funct3_i;
    wire [  `Funct7Bus] ex_funct7_i;
    wire [     `ImmBus] ex_imm_i;
    wire                ex_wreg_en_i;
    wire [ `RegAddrBus] ex_wreg_addr_i;
    wire [ `RegDataBus] ex_rs1_data_i;
    wire [ `RegDataBus] ex_rs2_data_i;

    // from ex to ex_mem
    wire                ex_wmem_en_o;
    wire                ex_rmem_en_o;
    wire [ `MemAddrBus] ex_mem_addr_o;
    wire [  `Funct3Bus] ex_funct3_o;
    wire                ex_wreg_en_o;
    wire [ `RegAddrBus] ex_wreg_addr_o;
    wire [ `RegDataBus] ex_wreg_data_o;

    // from ex_mem to mem
    wire                mem_wmem_en_i;
    wire                mem_rmem_en_i;
    wire [ `MemAddrBus] mem_mem_addr_i;
    //wire [    `WordBus] mem_mem_data_i;   // data from RAM IF LOAD
    wire [  `Funct3Bus] mem_funct3_i;
    wire                mem_wreg_en_i;
    wire [ `RegAddrBus] mem_wreg_addr_i;
    wire [ `RegDataBus] mem_wreg_data_i;  // IF STORE; the data(to be put in RAM) will be put here
    wire [    `WordBus] mem_wmem_data_i;

    // from mem to mem_wb
    wire                mem_wreg_en_o;
    wire [ `RegAddrBus] mem_wreg_addr_o;
    wire [ `RegDataBus] mem_wreg_data_o;
    wire [    `WordBus] mem_wmem_data_o;

    // between id and pc_reg
    wire                branch;
    wire [`InstAddrBus] pc2pcreg;

    // regfile
    wire                regfile_wreg_en_i;
    wire [ `RegAddrBus] regfile_wreg_addr_i;
    wire [ `RegDataBus] regfile_wreg_data_i;
    wire [ `RegAddrBus] regfile_rs1_addr_i;
    wire [ `RegAddrBus] regfile_rs2_addr_i;
    wire [ `RegDataBus] regfile_rs1_data_o;
    wire [ `RegDataBus] regfile_rs2_data_o;

    // ctrl
    wire                stallreq_id_i;
    wire                stallreq_ex_i;
    wire                stallreq_wb_i;
    wire [         4:0] stall;

    pc_reg inst_pc_reg (
        .clk (clk ),
        .rst_n (rst_n ),
        .jmp_en_i (branch ),
        .jmp_addr_i (pc2pcreg ),
        .hold_i (stall[0] ),
        .pc_o  ( pc)
    );
  
    if_id inst_if_id (
        .clk (clk ),
        .rst_n (rst_n ),
        .hold_i (stall[1] ),
        .jmp_en_i(branch),
        .pc_i (pc ),
        .inst_i (inst_i ),
        .pc_o (id_pc_i ),
        .inst_o  ( id_inst_i)
    );
  
    id inst_id (
        .rst_n (rst_n ),
        .pc_i (id_pc_i ),
        .inst_i (id_inst_i ),
        .ex_wreg_en_i (ex_wreg_en_o ),
        .ex_wreg_addr_i (ex_wreg_addr_o ),
        .ex_wreg_data_i (ex_wreg_data_o ),
        .mem_wreg_en_i (mem_wreg_en_o ),
        .mem_wreg_addr_i (mem_wreg_addr_o ),
        .mem_wreg_data_i (mem_wreg_data_o ),
        .rs1_data_i (regfile_rs1_data_o ),
        .rs2_data_i (regfile_rs2_data_o ),
        .branch_o (branch ),
        .pc2pcreg_o (pc2pcreg ),
        .pc2ex_o (id_pc2ex_o ),
        .wmem_en_o (id_wmem_en_o ),
        .rmem_en_o (id_rmem_en_o ),
        .opcode_o (id_opcode_o ),
        .funct3_o (id_funct3_o ),
        .funct7_o (id_funct7_o ),
        .imm_o (id_imm_o ),
        .wreg_en_o (id_wreg_en_o ),
        .wreg_addr_o (id_wreg_addr_o ),
        .rs1_addr_o (regfile_rs1_addr_i ),
        .rs1_data_o (id_rs1_data_o ),
        .rs2_addr_o (regfile_rs2_addr_i ),
        .rs2_data_o  (id_rs2_data_o)
    );
  
    id_ex inst_id_ex (
      .clk (clk ),
      .rst_n (rst_n ),
      .hold_i (stall[2] ),
      .id_pc_i (id_pc2ex_o ),
      .id_wmem_en_i (id_wmem_en_o ),
      .id_rmem_en_i (id_rmem_en_o ),
      .id_opcode_i (id_opcode_o ),
      .id_funct3_i (id_funct3_o ),
      .id_funct7_i (id_funct7_o ),
      .id_imm_i (id_imm_o ),
      .id_wreg_en_i (id_wreg_en_o ),
      .id_wreg_addr_i (id_wreg_addr_o ),
      .id_rs1_data_i (id_rs1_data_o ),
      .id_rs2_data_i (id_rs2_data_o ),
      .ex_pc_o (ex_pc_i ),
      .ex_wmem_en_o (ex_wmem_en_i ),
      .ex_rmem_en_o (ex_rmem_en_i ),
      .ex_opcode_o (ex_opcode_i ),
      .ex_funct3_o (ex_funct3_i ),
      .ex_funct7_o (ex_funct7_i ),
      .ex_imm_o (ex_imm_i ),
      .ex_wreg_en_o (ex_wreg_en_i ),
      .ex_wreg_addr_o (ex_wreg_addr_i ),
      .ex_rs1_data_o (ex_rs1_data_i ),
      .ex_rs2_data_o  ( ex_rs2_data_i)
    );
  
    ex inst_ex (
        .pc_i (ex_pc_i ),
        .wmem_en_i (ex_wmem_en_i ),
        .rmem_en_i (ex_rmem_en_i ),
        .opcode_i (ex_opcode_i ),
        .funct3_i (ex_funct3_i ),
        .funct7_i (ex_funct7_i ),
        .imm_i (ex_imm_i ),
        .wreg_en_i (ex_wreg_en_i ),
        .wreg_addr_i (ex_wreg_addr_i ),
        .rs1_data_i (ex_rs1_data_i ),
        .rs2_data_i (ex_rs2_data_i ),
        .wmem_en_o (ex_wmem_en_o ),
        .rmem_en_o (ex_rmem_en_o ),
        .mem_addr_o (ex_mem_addr_o ),
        .funct3_o (ex_funct3_o ),
        .wreg_en_o (ex_wreg_en_o ),
        .wreg_addr_o (ex_wreg_addr_o ),
        .wreg_data_o  ( ex_wreg_data_o)
    );

    ex_mem inst_ex_mem (
        .clk (clk ),
        .rst_n (rst_n ),
        .hold_i (stall[3] ),
        .ex_wmem_en_i (ex_wmem_en_o ),
        .ex_rmem_en_i (ex_rmem_en_o ),
        .ex_mem_addr_i (ex_mem_addr_o ),
        .ex_funct3_i (ex_funct3_o ),
        .ex_wreg_en_i (ex_wreg_en_o ),
        .ex_wreg_addr_i (ex_wreg_addr_o ),
        .ex_wreg_data_i (ex_wreg_data_o ),
        .mem_wmem_en_o (mem_wmem_en_i ),
        .mem_rmem_en_o (mem_rmem_en_i ),
        .mem_mem_addr_o (mem_mem_addr_i ),
        .mem_funct3_o (mem_funct3_i ),
        .mem_wreg_en_o (mem_wreg_en_i ),
        .mem_wreg_addr_o (mem_wreg_addr_i ),
        .mem_wreg_data_o  ( mem_wreg_data_i)
    );
    
    mem inst_mem (
        .wmem_en_i (mem_wmem_en_i ),
        .rmem_en_i (mem_rmem_en_i ),
        .mem_addr_i (mem_mem_addr_i ),
        .rmem_data_i (mem_rmem_data_i ),
        .funct3_i (mem_funct3_i ),
        .wreg_en_i (mem_wreg_en_i ),
        .wreg_addr_i (mem_wreg_addr_i ),
        .wreg_data_i (mem_wreg_data_i ),
        .wmem_en_o (wmem_en_o ),
        .rmem_en_o (rmem_en_o ),
        .mem_addr_o (mem_addr_o ),
        .wmem_data_o (mem_wmem_data_o ),
        .wreg_en_o (mem_wreg_en_o ),
        .wreg_addr_o (mem_wreg_addr_o ),
        .wreg_data_o  ( mem_wreg_data_o)
    );
  
    mem_wb inst_mem_wb (
        .clk (clk ),
        .rst_n (rst_n ),
        .hold_i (stall[4] ),
        .mem_wreg_en_i (mem_wreg_en_o ),
        .mem_wreg_addr_i (mem_wreg_addr_o ),
        .mem_wreg_data_i (mem_wreg_data_o ),
        .wb_wreg_en_o (regfile_wreg_en_i ),
        .wb_wreg_addr_o (regfile_wreg_addr_i ),
        .wb_wreg_data_o  ( regfile_wreg_data_i)
    );

    regfile inst_regfile (
      .clk (clk ),
      .rst_n (rst_n ),
      .r_addr1_i (regfile_rs1_addr_i ),
      .r_addr2_i (regfile_rs2_addr_i ),
      .w_en_i (regfile_wreg_en_i ),
      .w_addr_i (regfile_wreg_addr_i ),
      .w_data_i (regfile_wreg_data_i ),
      .r_data1_o (regfile_rs1_data_o ),
      .r_data2_o  ( regfile_rs2_data_o)
    );

    ctrl inst_ctrl(
        .rst_n(rst_n),
        .stallreq_id_i(stallreq_id_i),
        .stallreq_ex_i(stallreq_ex_i),
        .stallreq_wb_i(stallreq_wb_i),
        .enter_i(io_enter),
        .stall_o(stall)
    );
  
    assign rmem_data_i = mem_rmem_data_i;
    assign wmem_data_o = mem_wmem_data_o;
    assign rom_addr_o = pc;

endmodule //core_top
