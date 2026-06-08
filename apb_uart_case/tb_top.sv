`timescale 1ns/1ps
module tb_top;

  import uvm_pkg::*;
  import apb_pkg::*;

	logic PCLK;
  logic PCLKG;
  logic PRESETn;

  logic        RXD;
  logic        TXD;
  logic        TXEN;
  logic        BAUDTICK;
  logic        TXINT;
  logic        RXINT;
  logic        TXOVRINT;
  logic        RXOVRINT;
  logic        UARTINT;

  logic [3:0]  ECOREVNUM;

	apb_interface apb_vif (
    .PCLK    (PCLK),
    .PRESETn (PRESETn)
  );


	uart_interface uart_vif (
    .PCLK    (PCLK),
    .PRESETn (PRESETn)
		);

	cmsdk_apb_uart dut (
    .PCLK      (PCLK),
    .PCLKG     (PCLKG),
    .PRESETn   (PRESETn),

    .PSEL      (apb_vif.PSEL),
    .PADDR     (apb_vif.PADDR),
    .PENABLE   (apb_vif.PENABLE),
    .PWRITE    (apb_vif.PWRITE),
    .PWDATA    (apb_vif.PWDATA),
    .PRDATA    (apb_vif.PRDATA),
    .PREADY    (apb_vif.PREADY),
    .PSLVERR   (apb_vif.PSLVERR),

    .ECOREVNUM (ECOREVNUM),

    .RXD       (uart_vif.RXD),
    .TXD       (uart_vif.TXD),
    .TXEN      (uart_vif.TXEN),
    .BAUDTICK  (uart_vif.BAUDTICK),

    .TXINT     (uart_vif.TXINT),
    .RXINT     (uart_vif.RXINT),
    .TXOVRINT  (uart_vif.TXOVRINT),
    .RXOVRINT  (uart_vif.RXOVRINT),
    .UARTINT   (uart_vif.UARTINT)
  );

	initial begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;
  end
	assign PCLKG = PCLK;



	initial begin
    PRESETn = 0;
    ECOREVNUM = 4'h0;
		
		uart_vif.RXD = 1'b1;

    apb_vif.PSEL    = 1'b0;
    apb_vif.PENABLE = 1'b0;
    apb_vif.PWRITE  = 1'b0;
    apb_vif.PADDR   = '0;
    apb_vif.PWDATA  = '0;

    repeat (5) @(posedge PCLK);
    PRESETn = 1;
  end

	initial begin
    uvm_config_db#(virtual apb_interface)::set(
      null,
      "uvm_test_top.env.apb_agt*",
      "vif",
      apb_vif
    );

    uvm_config_db#(virtual uart_interface)::set(
      null,
      "uvm_test_top.*",
      "uart_vif",
      uart_vif
    );
    run_test();
  end

endmodule
