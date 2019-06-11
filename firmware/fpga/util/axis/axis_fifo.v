////////////////////////////////////////////////////////////////////////////////
// Company: 奥新智能
// Engineer: 耿慧慧
//
// Description
// Synchronous AXI-stream FIFO.
//
// Signals
// enable  :  N/A
// reset   :  active-high
// latency :  multiple
// output  :  registered
//
////////////////////////////////////////////////////////////////////////////////

module axis_fifo #(

  // parameters

  parameter   DATA_WIDTH = 8,
  parameter   FIFO_DEPTH = 16,

  // derived parameters

  localparam  ADDR_WIDTH = log2(FIFO_DEPTH - 1),

  // bit width parameters

  localparam  WD = DATA_WIDTH - 1,
  localparam  DF = FIFO_DEPTH - 1,
  localparam  WA = ADDR_WIDTH - 1

 ) (

  // core interface

  input             clk,
  input             ena,
  input             rst,

  // status signals

  output            full,
  output            empty,

  // slave interface

  input             s_axis_tvalid,
  output            s_axis_tready,
  input   [ WD:0]   s_axis_tdata,

  // master interace

  output            m_axis_tvalid,
  input             m_axis_tready,
  output  [ WD:0]   m_axis_tdata

 );

  `include "func_log2.vh"

  // internal memories

  reg     [ WD:0]   mem  [0:DF];

  // internal registers

  reg               wr_flag = 1'b0; // Flag write pointer to point to the top.
  reg               rd_flag = 1'b0; // Flag read pointer to point to the top.

  reg     [ WD:0]   mem_dout = 'b0;
  reg     [ WD:0]   fifo_dout = 'b0;
  reg     [ WD:0]   fifo_reg = 'b0;

  reg               fifo_valid = 1'b0;
  reg               fifo_full = 1'b0;
  reg               fifo_empty = 1'b1;

  reg               m_axis_tvalid_reg = 1'b0;

  // internal signals

  wire              m_axis_frame;

  wire              wr_ena;
  wire              rd_ena;
  wire    [ WA:0]   wr_addr;
  wire    [ WA:0]   rd_addr;

  /* Output status signals.
   */

  assign full = fifo_full;
  assign empty = fifo_empty;

  /* FIFO glue logic.
   */

  assign wr_ena = s_axis_tvalid & s_axis_tready;
  assign rd_ena = (~m_axis_tvalid | m_axis_frame) & !fifo_empty;
  assign m_axis_tdata = fifo_dout;
  assign m_axis_frame = m_axis_tvalid & m_axis_tready;

  /*
   * FIFO_DEPTH == 1,does not use the address pointer, can simplify the logic.
   * Others must use an address pointer to identify the location of the read
   * and write.
   */

  genvar n;
  generate
  if (FIFO_DEPTH == 1) begin

    /* "Write" logic.
     */

    always @(posedge clk) begin
      if (rst) begin
        fifo_reg <= 'b0;
      end else if (ena & wr_ena) begin
        fifo_reg <= s_axis_tdata;
      end else begin
        fifo_reg <= fifo_reg;
      end
    end

    /* Empty/full indicator.
     * Since this version of the FIFO has only one element, there is no need
     * for both fifo_empty and fifo_full signals; one is enough to track both
     * statuses.
     */

    always @(posedge clk) begin
      if (rst) begin
        fifo_empty <= 1'b1;
      end else if (!ena) begin
        fifo_empty <= fifo_empty;
      end else if ((!fifo_empty | wr_ena) & !rd_ena) begin
        fifo_empty <= 1'b0;
      end else begin
        fifo_empty <= 1'b1;
      end
    end

    /* "Read" logic.
     */

    always @(posedge clk) begin
      if (rst) begin
        fifo_dout <= 'b0;
        fifo_valid <= 1'b0;
      end else if (ena & rd_ena) begin
        fifo_dout <= fifo_reg;
        fifo_valid <= 1'b1;
      end else begin
        fifo_dout <= fifo_dout;
        fifo_valid <= fifo_valid;
      end
    end

    assign m_axis_tvalid = fifo_valid;
    assign s_axis_tready = fifo_empty;

  end else begin

    // slave interface

    always @(posedge clk) begin
      if (rst) begin
        fifo_valid <= 1'b0;
        m_axis_tvalid_reg <= 1'b0;
      end else if (ena & ~m_axis_tvalid | m_axis_frame) begin
        fifo_valid <= !fifo_empty;
        m_axis_tvalid_reg <= fifo_valid;
      end else begin
        fifo_valid <= fifo_valid;
        m_axis_tvalid_reg <= m_axis_tvalid_reg;
      end
    end

    assign s_axis_tready = ~fifo_full;
    assign m_axis_tvalid = m_axis_tvalid_reg;

    /* Write pointer
     * Always points to the next unit to be written when reset, points to the first
     * unit.
     */

    counter #(
      .LOWER (0),
      .UPPER (DF),
      .WRAPAROUND (1),
      .INIT_VALUE (0)
    ) counter_wr_addr (
      .clk (clk),
      .rst (rst),
      .ena (ena & wr_ena),
      .value (wr_addr)
    );

    // Write flag logic

    always @(posedge clk) begin
      if (rst) begin
        wr_flag <= 1'b0;
      end else if (ena & wr_ena & (wr_addr == DF)) begin
        wr_flag <= wr_flag + 1'b1;
      end else begin
        wr_flag <= wr_flag;
      end
    end

    /* Write to FIFO
     * No data is written at reset.
     */

    always @(posedge clk) begin
      if (ena & wr_ena) begin
        mem[wr_addr] <= s_axis_tdata;
      end
    end

    /* Read pointer
     * Always points to the next unit to be read when reset, points to the first
     * unit.
     */

    counter #(
      .LOWER (0),
      .UPPER (DF),
      .WRAPAROUND (1),
      .INIT_VALUE (0)
    ) counter_rd_addr (
      .clk (clk),
      .rst (rst),
      .ena (ena & rd_ena),
      .value (rd_addr)
    );

    // Read flag logic

    always @(posedge clk) begin
      if (rst) begin
        rd_flag <= 1'b0;
      end else if (ena & rd_ena & (rd_addr == DF)) begin
        rd_flag <= rd_flag + 1'b1;
      end else begin
        rd_flag <= rd_flag;
      end
    end

    /* Read from FIFO
     * Readout is 0 when the reset or FIFO status is empty.
     */

    always @(posedge clk) begin
      if (ena & rd_ena) begin
        mem_dout <= mem[rd_addr];
      end
    end

    always @(posedge clk) begin
      if (rst) begin
        fifo_dout <= 'b0;
      end else if (ena & ~m_axis_tvalid | m_axis_frame) begin
        fifo_dout <= mem_dout;
      end else begin
        fifo_dout <= fifo_dout;
      end
    end

    /* FIFO status
     * When the read pointer and the write pointer are the same, if the two pointer
     * flags are different, it means that the write pointer is folded back more than
     * the read pointer and is full. if the two pointer flags are the same, it means
     * that the two pointers are folded back the same number of times and are empty.
     */

    always @* begin
      if ((wr_addr == rd_addr) & (rd_flag == !wr_flag)) begin
        fifo_full = 1'b1;
      end else begin
        fifo_full = 1'b0;
      end
    end

    always @* begin
      if ((wr_addr == rd_addr) & (rd_flag == wr_flag)) begin
        fifo_empty = 1'b1;
      end else begin
        fifo_empty = 1'b0;
      end
    end

  end
  endgenerate

endmodule
