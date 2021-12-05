`include "../headers/buceros_header.v"
module id (
    input  wire               nrst,
    input  wire [`RegAddrBus] pc_i,
    input  wire [`RegDataBus] inst_i,
    input  wire               ex_wreg_en_i,
    input  wire [`RegAddrBus] ex_wreg_addr_i,
    input  wire [`RegDataBus] ex_wreg_data_i,
    input  wire               mem_wreg_en_i,
    input  wire [`RegAddrBus] mem_wreg_addr_i,
    input  wire [`RegDataBus] mem_wreg_data_i,
    input  wire [`RegDataBus] reg1_data_i,
    input  wire [`RegDataBus] reg2_data_i,


    output wire               wmem_en_o,
    output wire               rmem_en_o,
    output wire [`OpcodeBus]  opcode_o,
    output wire [`Funct3Bus]  funct3_o,
    output wire [`Funct7Bus]  funct7_o,
    output wire [   `ImmBus]  imm_o,
    output wire               wreg_en_o,
    output wire [`RegAddrBus] wreg_addr_o,
    output wire               reg1_en_o,
    output wire               reg2_en_o,
    output wire [`RegAddrBus] rs1_addr_o,
    output wire [`RegDataBus] rs1_data_o,
    output wire [`RegAddrBus] rs2_addr_o,
    output wire [`RegDataBus] rs2_data_o
);
    //constructed by integrated logical circuits

    //para1 directed connected signals about rs1,rs2
    //step1:rs1 selected signal
    always @(*) begin
    if (nrst == `NrstEnable) 
        reg1_data_o =  `ZeroWord;
    else if((reg1_en_o == `Enable) && (ex_wreg_addr_i == rs1_addr_o) && (ex_wreg_en_i == `Enable))
        rs1_data_o = ex_wreg_data_i;
    else if((reg1_en_o == `Enable) && (mem_wreg_addr_i == rs1_addr_o) && (mem_wreg_en_i == `Enable))
        rs1_data_o = mem_wreg_data_i;
    else if((reg1_en_o == `Enable))
        rs1_data_o = reg1_data_i;
    else 
        rs1_data_o = `ZeroWord;
    end
    //step2:rs2 selected signal
    always @(*) begin
        if (nrst == `NrstEnable) 
            reg2_data_o =  `ZeroWord;
        else if((reg2_en_o == `Enable) && (ex_wreg_addr_i == rs2_addr_o) && (ex_wreg_en_i == `Enable))
            rs2_data_o = ex_wreg_data_i;
        else if((reg2_en_o == `Enable) && (mem_wreg_addr_i == rs2_addr_o) && (mem_wreg_en_i == `Enable))
            rs2_data_o = mem_wreg_data_i;
        else if((reg2_en_o == `Enable))
            rs2_data_o = reg2_data_i;
        else 
            rs2_data_o = `ZeroWord;
        end

    //para2 analyse and segment the instruction
    assign opcode_o = inst_i [OpcodeBus];
    always @(*) begin
        if(nrst == `NrstEnable) begin
        wmem_en_o   = `Disable;
        rmem_en_o   = `Disable;
        funct7_o    = `Disable;
        funct3_o    = `Disable;
        imm_o       = `Disable;
        wreg_en_o   = `Disable;
        wreg_addr_o = `Disable;
        reg1_en_o   = `Disable;
        reg2_en_o   = `Disable;
        end
        else begin
        reg1_en_o   = `Enable;
        reg2_en_o   = `Enable;
        
        case(opcode_o) 
            `U_Type_Plus :  begin
            imm_o       = (inst_i [31:12] << 12);        
            wreg_addr_o = inst_i [11:7];
            wreg_en_o   = `Enable;
            reg1_en_o   = `Disable;
            reg2_en_o   = `Disable;
            wmem_en_o   = `Disable;
            rmem_en_o   = `Disable;
            funct7_o    = `Disable;
            funct3_o    = `Disable;
            end
            `U_Type : begin
            imm_o       = (inst_i [31:12] << 12) + pc_i;        
            wreg_addr_o = inst_i [11:7];
            wreg_en_o   = `Enable;
            reg1_en_o   = `Disable;
            reg2_en_o   = `Disable;
            wmem_en_o   = `Disable;
            rmem_en_o   = `Disable;
            funct7_o    = `Disable;
            funct3_o    = `Disable;
            end
            `J_Type :  begin
            imm_o       = (inst_i [31:12] << 12) + pc_i;        
            wreg_addr_o = inst_i [11:7];
            wreg_en_o   = `Enable;
            reg1_en_o   = `Disable;
            reg2_en_o   = `Disable;
            wmem_en_o   = `Disable;
            rmem_en_o   = `Disable;
            funct7_o    = `Disable;
            funct3_o    = `Disable;
endmodule //id