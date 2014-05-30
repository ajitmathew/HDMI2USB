`timescale 1ns/1ps
module Tb;

reg [7:0] w_data;
reg clk,rst;
wire[7:0] r_data;
wire data_line;

reg wr_uart;
reg rd_uart;
wire tx_full,rx_empty;

integer k;



transmitter Tx(clk,rst,w_data,wr_uart,tx_full,data_line);
		            
receiver Rx( rd_uart,data_line,clk,rst,rx_empty,r_data);


always #10 clk=~clk;

initial
begin
  clk=0;
  rst=0;
  wr_uart=0;
  rd_uart=0;
  #50000;
  rst=1;
  #40000;
  rst=0;  

  for (k=0;k<=10;k=k+1)
  begin
      w_data=$random;wr_uart=1;
      #20;
      wr_uart=0;

      #1240000;
      $display("w_data: %d  r_data :%d  rx_empty : %b /n",w_data,r_data,rx_empty);

      if(w_data==r_data) 
      begin
         $display("Correct/n");
      end
      else 
      begin
      $display("Wrong/n");
      end
      rd_uart=1;
      #40;
      rd_uart=0;
  end
$finish;
end

endmodule