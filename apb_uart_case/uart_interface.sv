interface uart_interface (
  input logic PCLK,
  input logic PRESETn
);

  logic RXD;
  logic TXD;
  logic TXEN;
  logic BAUDTICK;

  logic TXINT;
  logic RXINT;
  logic TXOVRINT;
  logic RXOVRINT;
  logic UARTINT;

  clocking tx_mon_cb @(posedge PCLK);
    default input #1step output #1step;

    input RXD;
    input TXD;
    input TXEN;
    input BAUDTICK;

    input TXINT;
    input RXINT;
    input TXOVRINT;
    input UARTINT;
  endclocking

endinterface : uart_interface
