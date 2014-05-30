`timescale 1ns/1ps
module Tb;

reg clk, reset;
reg tx_start;
reg [7:0] din;
wire [3:0] q;
wire s_tick;
uart_tx DUT (clk, reset,tx_start, s_tick,din,tx_done_tick,tx);
mod_m_counter support(clk, reset,s_tick,q);

always #10 clk=~clk; 

initial
begin
clk=0;
  reset=0;tx_start=0;din=0;
  #5; 
  reset=1;
  #8;
  reset=0;din=8'b11110000;tx_start=1;
  #500;
  tx_start=0;
  @(posedge tx_done_tick) ;
  reset=0;din=8'b11001100;tx_start=1;
  #500;
  tx_start=0;
  @(posedge tx_done_tick) ;
  #200; 
  reset=0;din=8'b00000000;tx_start=1;
  #500;
  tx_start=0;
  #500;
  reset=0;din=8'b11111111;tx_start=1;
  #500;
  tx_start=0;
  #500;
  reset=0;din=0;tx_start=1;
  #500;
  tx_start=0;
  #500;
  reset=0;din=8'b11111111;tx_start=1;
  #500;
  tx_start=0;
  #500;
  reset=0;din=8'b11111111;tx_start=1;
  #500;
  tx_start=0;
  #500;
  @(posedge tx_done_tick) ;
  reset=0;din=8'b11111111;tx_start=1;
  #500;
  reset=1;din=0;tx_start=0;
  #500;
  reset=0;din=8'b11001100;tx_start=1;
  #500;
  tx_start=0;
  #500;
  @(posedge tx_done_tick);
  #500;
  $finish;    
end
endmodule