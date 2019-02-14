////////////////////////////////////////////////////////////////////////////////
// Company: 奥新智能
// Engineer: Frank Liu
//
// Description
// AXI-stream distributor. Similar to axis_fan_out but sends the same data to
// all channels, i.e. waits for all channels to assert tready before updating
// the bus data (m_axis_tdata).
//
// Signals
// enable  :  N/A
// reset   :  active-high
// latency :  1 cycle
// output  :  registered
//
////////////////////////////////////////////////////////////////////////////////

module axis_distrib #(

  // parameters

  parameter   NUM_DISTRIB = 6,
  parameter   DATA_WIDTH = 128,
  parameter   USE_FIFO = 0,
  parameter   FIFO_TYPE = "auto",
  parameter   FIFO_DEPTH = 32,
  parameter   FIFO_LATENCY = 2,

  // derived parameters

  localparam  PACKED_WIDTH = NUM_DISTRIB * DATA_WIDTH,
  localparam  SELECT_WIDTH = log2(NUM_DISTRIB - 1),

  // bit width parameters

  localparam  ND = NUM_DISTRIB - 1,
  localparam  WD = DATA_WIDTH - 1,
  localparam  WP = PACKED_WIDTH - 1,
  localparam  WS = SELECT_WIDTH - 1

) (

  // core interface

  input             s_axis_clk,
  input             s_axis_rst,
  input             m_axis_clk,

  // slave interface

  input             s_axis_tvalid,
  output            s_axis_tready,
  input   [ WD:0]   s_axis_tdata,

  // master interace

  output  [ ND:0]   m_axis_tvalid,
  input   [ ND:0]   m_axis_tready,
  output  [ WP:0]   m_axis_tdata

);

  `include "func_log2.vh"

  // internal registers

  reg     [ ND:0]   ready_all = 'b0;

  // internal signals

  wire              distrib_frame;
  wire              distrib_valid;
  wire              distrib_ready;
  wire    [ WD:0]   distrib_data;

  wire              m_axis_frame;

  /* Assign inputs.
   * If a FIFO is not requested, directly assign inputs to s_axis.
   */

  generate
  if (USE_FIFO) begin

    axis_fifo_async #(
      .MEMORY_TYPE (FIFO_TYPE),
      .DATA_WIDTH (DATA_WIDTH),
      .FIFO_DEPTH (FIFO_DEPTH),
      .READ_LATENCY (FIFO_LATENCY)
    ) axis_fifo_async (
      .s_axis_clk (s_axis_clk),
      .s_axis_rst (s_axis_rst),
      .m_axis_clk (m_axis_clk),
      .s_axis_tvalid (s_axis_tvalid),
      .s_axis_tready (s_axis_tready),
      .s_axis_tdata (s_axis_tdata),
      .m_axis_tvalid (distrib_valid),
      .m_axis_tready (distrib_ready),
      .m_axis_tdata (distrib_data)
    );

  end else begin

    assign s_axis_tready = distrib_ready;
    assign distrib_valid = s_axis_tvalid;
    assign distrib_data = s_axis_tdata;

  end
  endgenerate

  /* Slave interface.
   * The output ready signal goes high only when ALL channels are ready to
   * accept new data. Although this causes one extra cycle of throughput delay,
   * there is no other way to accomplish AXI-stream distribution since at least
   * one set of flops is required to store state.
   */

  assign distrib_frame = distrib_valid & distrib_ready;
  assign distrib_ready = &(ready_all);

  /* Ready logic.
   * Whenever new data is framed from the slave AXI-stream interface, the
   * internal ready logic for all output channels goes low. These signals go
   * high again only after the master AXI-stream has accepted the data. Since
   * the downstream modules can be running at different speeds, state is stored
   * between clock cycles to denote when each downstream module has framed the
   * "current" data.
   */

  always @(posedge m_axis_clk) begin
    if (distrib_frame) begin
      ready_all <= 'b0;
    end else begin
      ready_all <= ready_all | m_axis_frame;
    end
  end

  /* Master interface.
   * Mostly straightfoward. Data is provided to the downstream modules only if
   * the current data has not already been input.
   */

  assign m_axis_frame = m_axis_tvalid & m_axis_tready;
  assign m_axis_tvalid = distrib_valid ? ~ready_all : 'b0;
  assign m_axis_tdata = {NUM_DISTRIB{distrib_data}};

endmodule

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
