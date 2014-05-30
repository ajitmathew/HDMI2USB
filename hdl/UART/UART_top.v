
module UART_top(	
		input wire clk,reset,
// Transmitter Signals
		input wire[7:0] w_data,
		input wire w_uart,
		output wire tx_fifo_full,
		output wire tx,
//Reciever Signal
      input  wire r_uart,
		input  wire rx,
   	output wire rx_fifo_empty,
		output wire[7:0]r_data
		
    );
wire clkout;
clk_wiz_v3_6 USART_CLOCK(clk,clkout);
transmitter Tx(clkout,reset,w_data,w_uart,tx_fifo_full,tx);
receiver Rx( r_uart,rx,clkout,reset,rx_fifo_empty,r_data);


endmodule
