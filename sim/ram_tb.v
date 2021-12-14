`include "../src/headers/buceros_header.v"

module ram_tb;

  // Parameters
  localparam  RAM_DEPTH = 16384;
  localparam  RAM_DEPTH_BIT_LEN = 14;

  // Ports
  reg  clk = 0;
  reg  rst_n = 0;
  reg [`MemAddrBus] r_addr1_i;
  reg [`MemAddrBus] r_addr2_i;
  reg  w_en_i = 0;
  reg [`MemAddrBus] w_addr_i;
  reg [   `WordBus] w_data_i;
  reg [        3:0] w_sel_i;
  wire [   `WordBus] r_data1_o;
  wire [   `WordBus] r_data2_o;

  ram 
  #(
    .RAM_DEPTH(RAM_DEPTH ),
    .RAM_DEPTH_BIT_LEN (
        RAM_DEPTH_BIT_LEN )
  )
  ram_dut (
    .clk (clk ),
    .rst_n (rst_n ),
    .r_addr1_i (r_addr1_i ),
    .r_addr2_i (r_addr2_i ),
    .w_en_i (w_en_i ),
    .w_addr_i (w_addr_i ),
    .w_data_i (w_data_i ),
    .w_sel_i (w_sel_i ),
    .r_data1_o (r_data1_o ),
    .r_data2_o  ( r_data2_o)
  );

  initial begin
    begin
    #1 rst_n = 1;
    r_addr1_i = 0;
    r_addr2_i = 1;
    w_addr_i = 10;
      repeat (100000) begin
        #10 r_addr1_i = r_addr1_i + 1;
        r_addr2_i = r_addr2_i + 1;
        w_en_i = $random;
        w_addr_i = w_addr_i +1;
        w_data_i = $random;
        w_sel_i = $random;
      end
    end
  end

  always
    #5  clk = ! clk ;

endmodule
