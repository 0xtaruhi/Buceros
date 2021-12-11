`ifndef _PERIPS_HEADER_V_
`define _PERIPS_HEADER_V_

`define MemAddrBus                          31:0
`define MemDataBus                          31:0
`define WordBus                             31:0

`define ROM_WIDTH                           32
`define HALF_WORD_WIDTH                     16
`define BYTE_WIDTH                          8
`define RomBus                              31:0
`define RomAddrBus                          31:0

`define UART_BAUD_RATE                      115200
`define UART_DIV_CNT_MAX                    10'd868         // 115200
`define UART_DIV_CNT_HALF                   10'd434         // 115200
`define UART_DIV_W                          10
`define UartDivBus                          9:0

`endif