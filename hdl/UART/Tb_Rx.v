`timescale 1ns/1ps
module Tb;

reg clk, reset;
reg rx;
wire s_tick;
wire [7:0] dout;
wire [3:0] q;
integer i;

uart_rx DUT (clk,reset,rx,s_tick,rx_done_tick,dout);
mod_m_counter support(clk, reset,s_tick,q);

always #10 clk=~clk; 

initial
begin
  clk=0;
  reset=0;rx=0;
  #320;
  reset=1;
  #200;
  reset=0;
  rx=0;@(posedge s_tick);
  #20;
  rx=1;
   for (i=0;i<16;i=i+1)
   begin
   @(posedge s_tick);
    end
  rx=0;
   for (i=0;i<16;i=i+1)
   begin
   @(posedge s_tick);
   end

  rx=1;
   for (i=0;i<16;i=i+1)
   begin
   @(posedge s_tick);
   end
  rx=0;
   for (i=0;i<16;i=i+1)
   begin
   @(posedge s_tick);
   end
  rx=1;
   for (i=0;i<16;i=i+1)
   begin
   @(posedge s_tick);
   end
  rx=0;
   for (i=0;i<16;i=i+1)
   begin
   @(posedge s_tick);
   end
  rx=1;
   for (i=0;i<16;i=i+1)
   begin
   @(posedge s_tick);
   end
  rx=0;
   for (i=0;i<16;i=i+1)
   begin
   @(posedge s_tick);
   end
  rx=1;
  @(posedge rx_done_tick);
  #2000;
  $finish;  
end
endmodule