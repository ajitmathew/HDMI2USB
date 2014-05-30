// Default setting: 19,200 baud, 8 data bits, 1 stop bit, 2^2 FIFO
module receiver#( 
      parameter DBIT = 8,     
                SB_tck = 16, 
                DVSR = 326,    // divider circuit = 50M/(16*baud rate)
                DVSR_BIT = 9, // # bits of divider circuit
                FIFO_W = 2    
                             
   )
	( 				  input  wire rd_uart,
					  input  wire rx,
					  input  wire clk,reset,
					  output wire rx_empty,
					  output wire[7:0]r_data
	);
	wire tck, rx_done_tck;
	wire [7:0] rx_data_out;
	wire [7:0] q;
	
fifo #(.B(DBIT), .W(FIFO_W)) fifo_rx_unit
      (.clk(clk), .reset(reset), .rd(rd_uart),
       .wr(rx_done_tck), .w_data(rx_data_out),
       .empty(rx_empty), .full(), .r_data(r_data));
		 
uart_rx #(.DBIT(DBIT), .SB_tck(SB_tck)) uart_rx_unit
      (.clk(clk), .reset(reset), .rx(rx), .s_tck(tck),
       .rx_done_tck(rx_done_tck), .dout(rx_data_out));

mod_m_counter #(.M(DVSR), .N(DVSR_BIT)) baud_gen_unit
      (.clk(clk), .reset(reset), .q(), .max_tck(tck));
		
endmodule