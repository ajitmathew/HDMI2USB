`timescale 1ns / 1ps

module tb(
    );

   reg clk;
   reg pixclk;
   reg rst;
   wire rst_n;
	
	
	wire [15:0]mcb3_dram_dq;
	wire [12:0]mcb3_dram_a;
	wire [2:0] mcb3_dram_ba;
	wire mcb3_dram_ras_n; 
	wire mcb3_dram_cas_n;
	wire mcb3_dram_we_n;
	wire mcb3_dram_cke;
	wire mcb3_dram_dm;
	wire mcb3_dram_udqs;
	wire mcb3_dram_udqs_n;
	wire mcb3_rzq;
	wire mcb3_zio;
	wire mcb3_dram_udm;
	wire mcb3_dram_odt;
	wire mcb3_dram_dqs;
	wire mcb3_dram_dqs_n;
	wire mcb3_dram_ck;
	wire mcb3_dram_ck_n;
	
	wire [3:0] RX0_TMDS,TX0_TMDS,TX1_TMDS,RX1_TMDS;
	wire [3:0] RX0_TMDSB,RX1_TMDSB,TX0_TMDSB,TX1_TMDSB;
	
	wire TMDSp_clock;
	wire [2:0] TMDSp;
	wire TMDSn_clock;
	wire [2:0] TMDSn;
	wire zero;
	
	
	wire[23:0] iram_wdata_s;
	wire iram_wren_s;
	wire iram_fifo_afull_s; 
	
	
	wire [7:0]ram_byte_s;
	wire ram_wren_s;
	wire [23:0]ram_wraddr_s;  
	
	wire [15:0] resx_s;
	wire [15:0] resy_s;

	wire start_s;
	wire done_s	;
	wire busy_s;
	

PULLDOWN zio_pulldown3 (.O(mcb3_rzio));
PULLDOWN rzq_pulldown3 (.O(mcb3_rzq ));
ddr2_model_c3 DRAM(
	   .ck         (mcb3_dram_ck),
		.ck_n       (mcb3_dram_ck_n),
		.cke        (mcb3_dram_cke),
		.cs_n       (1'b0),
		.ras_n      (mcb3_dram_ras_n),
		.cas_n      (mcb3_dram_cas_n),
		.we_n       (mcb3_dram_we_n),
		.dm_rdqs    ({mcb3_dram_udm,mcb3_dram_dm}),
		.ba         (mcb3_dram_ba),
		.addr       (mcb3_dram_a),
		.dq         (mcb3_dram_dq),
		.dqs        ({mcb3_dram_udqs,mcb3_dram_dqs}),
		.dqs_n      ({mcb3_dram_udqs_n,mcb3_dram_dqs_n}),
		.rdqs_n     (),
		.odt        (mcb3_dram_odt)
	);
	
	Hdmi2usb UUT (
    .RX0_TMDS(RX0_TMDS), 
    .RX0_TMDSB(RX0_TMDSB), 
    .TX0_TMDS(TX0_TMDS), 
    .TX0_TMDSB(TX0_TMDSB), 
    .RX1_TMDS(RX1_TMDS), 
    .RX1_TMDSB(RX1_TMDSB), 
    .TX1_TMDS(TX1_TMDS), 
    .TX1_TMDSB(TX1_TMDSB), 
    .btnc(zero), 
    .btnu(zero), 
    .btnl(zero), 
    .btnr(zero), 
    .btnd(zero), 
    .mcb3_dram_dq(mcb3_dram_dq), 
    .mcb3_dram_a(mcb3_dram_a), 
    .mcb3_dram_ba(mcb3_dram_ba), 
    .mcb3_dram_ras_n(mcb3_dram_ras_n), 
    .mcb3_dram_cas_n(mcb3_dram_cas_n), 
    .mcb3_dram_we_n(mcb3_dram_we_n), 
    .mcb3_dram_cke(mcb3_dram_cke), 
    .mcb3_dram_dm(mcb3_dram_dm), 
    .mcb3_dram_udqs(mcb3_dram_udqs), 
    .mcb3_dram_udqs_n(mcb3_dram_udqs_n), 
    .mcb3_rzq(mcb3_rzq), 
    .mcb3_zio(mcb3_zio), 
    .mcb3_dram_udm(mcb3_dram_udm), 
    .mcb3_dram_odt(mcb3_dram_odt), 
    .mcb3_dram_dqs(mcb3_dram_dqs), 
    .mcb3_dram_dqs_n(mcb3_dram_dqs_n), 
    .mcb3_dram_ck(mcb3_dram_ck), 
    .mcb3_dram_ck_n(mcb3_dram_ck_n), 
    .rst_n(rst_n), 
    .clk(clk),
	  .iram_wdata_s(iram_wdata_s), 
    .iram_wren_s(iram_wren_s), 
    .iram_fifo_afull_s(iram_fifo_afull_s), 
    .ram_byte_s(ram_byte_s), 
    .ram_wren_s(ram_wren_s), 
    .ram_wraddr_s(ram_wraddr_s), 
    .resx_s(resx_s), 
    .resy_s(resy_s), 
    .start_s(start_s), 
    .done_s(done_s), 
    .busy_s(busy_s)
    );
HDMI_test HDMI_model (
    .pixclk(pixclk), 
    .TMDSp(TMDSp), 
    .TMDSn(TMDSn), 
    .TMDSp_clock(TMDSp_clock), 
    .TMDSn_clock(TMDSn_clock)
    );
assign RX0_TMDS = {TMDSp_clock,TMDSp};
assign RX0_TMDSB= {TMDSn_clock,TMDSn};
assign rst_n=(!rst);
assign zero=0;
initial 
begin
	rst=1;
	clk=0;
	pixclk=0;
	#50
	rst=0;
end
	
	
	always begin
		#5 ; clk = ~clk; // 100 MHz system clock
	end
	
	always begin
		#20; pixclk=~pixclk;
	end
endmodule
