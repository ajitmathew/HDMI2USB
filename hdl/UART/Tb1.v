`timescale 1ns/1ps
module Tb;

reg [7:0] w_data;
reg clk,rst;
wire[7:0] r_data;
wire data_line;

reg wr_uart;
reg rd_uart;
wire tx_full,rx_empty;

integer k,l=0;

transmitter Tx(clk,rst,w_data,wr_uart,tx_full,data_line);
		            
receiver Rx( rd_uart,data_line,clk,rst,rx_empty,r_data);

always #10 clk=~clk;

initial
begin
  clk=0;rst=0;wr_uart=0;rd_uart=0;
  #5000;
  rst=1;
  #10000;
  rst=0;  
  for (k=1;k<=5;k=k+1)
  begin
    w_data=$random;wr_uart=1;
    #20;
    wr_uart=0;
    #100000;
    $display("w_data----%d : %d ",k,w_data);
  end
  #4800000;
  $finish;
end
  
always@(posedge clk)
begin
if(rx_empty!=1)
  begin
    l=l+1;
    $display("r_data----%d : %d ",l,r_data);
    #230000;
    rd_uart=1;
    #2300;
    rd_uart=0;
  
  end
end
  
endmodule
