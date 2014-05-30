// Default setting:9600 baud, 8 data bits, 1 stop bit, 2^2 FIFO

module transmitter#( 
      parameter DBIT = 8,
                SB_tck = 16, 
                DVSR = 326,   // baud rate divisor Divider circuit = 50M/(16*baud rate)
                DVSR_BIT = 9, // # bits of Divider circuit
                FIFO_W = 5   
   )
	(
		input wire clk,reset,
		input wire[7:0] w_data,
		input wire wr_uart,
		output wire tx_full,
		output wire tx
	);
	
	wire tck, tx_done_tck;
   wire tx_empty, tx_fifo_not_empty;
   wire [7:0] tx_fifo_out;
   wire [7:0] q;
	
	mod_m_counter #(.M(DVSR), .N(DVSR_BIT)) baud_gen_unit
      (.clk(clk), .reset(reset), .q(), .max_tck(tck));

	fifo #(.B(DBIT), .W(FIFO_W)) fifo_tx_unit
      (.clk(clk), .reset(reset), .rd(tx_done_tck),
       .wr(wr_uart), .w_data(w_data), .empty(tx_empty),
       .full(tx_full), .r_data(tx_fifo_out));
	
	uart_tx #(.DBIT(DBIT), .SB_tck(SB_tck)) uart_tx_unit
      (.clk(clk), .reset(reset), .tx_start(tx_fifo_not_empty),
       .s_tck(tck), .din(tx_fifo_out),
       .tx_done_tck(tx_done_tck), .tx(tx));
		 
	assign tx_fifo_not_empty = !tx_empty;
		 
endmodule

