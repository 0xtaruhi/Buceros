`ifndef _PERIPS_HEADER_V_
`define _PERIPS_HEADER_V_
<<<<<<< HEAD
//rom register
`define InstAddrBus                         31:0
`define InstBus                             31:0 
`define ROM_WIDTH                           8
`define RomBus                              7:0
`define RomAddrBus                          65535:0
//ram register
`define RAM_WIDTH                           8
`define RamBus                              7:0
`define RamAddrBus                          65535:0
`define DataBus                             31:0
`define DataAddrBus                         31:0                  
=======

`define ROM_WIDTH                           32
`define RomBus                              31:0
`define RomAddrBus                          31:0

`define UART_BAUD_RATE                      115200
`define UART_DIV_CNT_MAX                    10'd868         // 115200
`define UART_DIV_CNT_HALF                   10'd434         // 115200
`define UART_DIV_W                          10
`define UartDivBus                          9:0
`endif