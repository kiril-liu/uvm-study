interface apb_interface(
	input logic PCLK,
	input logic PRESETn
	);
	logic        PSEL;
	logic [11:2] PADDR;
	logic        PENABLE;
	logic        PWRITE;
	logic [31:0] PWDATA;
	logic [31:0] PRDATA;
	logic        PREADY;
	logic        PSLVERR;


  clocking drv_cb @(posedge PCLK);
    default input #1step output #1step;

    output PSEL;
    output PADDR;
    output PENABLE;
    output PWRITE;
    output PWDATA;

    input  PRDATA;
    input  PREADY;
    input  PSLVERR;
  endclocking

	  modport DRV_MP (
    clocking drv_cb,
    input PCLK,
    input PRESETn
  );

	clocking mon_cb @(posedge PCLK);
    default input #1step output #1step;

    input PSEL;
    input PADDR;
    input PENABLE;
    input PWRITE;
    input PWDATA;
    input PRDATA;
    input PREADY;
    input PSLVERR;
  endclocking

  modport MON_MP (
    clocking mon_cb,
    input PCLK,
    input PRESETn
  );

endinterface
