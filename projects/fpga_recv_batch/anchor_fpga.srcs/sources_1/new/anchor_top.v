////////////////////////////////////////////////////////////////////////////////
// Company: 奥新智能
// Engineer: Frank Liu
//
// Description
// Anchor top-level module.
//
// Signals
// enable  :  N/A
// reset   :  N/A
// latency :  N/A
// output  :  N/A
//
////////////////////////////////////////////////////////////////////////////////

module anchor_top (

  // master interface

  input             clk,

  // physical interface (receive_a)

  input             a_rx_clk_in,
  input             a_rx_frame_in,
  input   [ 11:0]   a_rx_data_p0,
  input   [ 11:0]   a_rx_data_p1,

  // physical interface (receive_b)

  input             b_rx_clk_in,
  input             b_rx_frame_in,
  input   [ 11:0]   b_rx_data_p0,
  input   [ 11:0]   b_rx_data_p1,

  // physical interface (control)

  output            sync_out,
  output            a_resetb,
  output            a_enable,
  output            a_txnrx,
  output            b_resetb,
  output            b_enable,
  output            b_txnrx,

  // physical interface (spi_a)

  output            a_spi_sck,
  output            a_spi_di,
  input             a_spi_do,
  output            a_spi_cs,

  // physical interface (spi_b)

  output            b_spi_sck,
  output            b_spi_di,
  input             b_spi_do,
  output            b_spi_cs,

  // microprocessor interface (spi)

  input             spi_sck,
  input             spi_mosi,
  output            spi_miso,
  input             spi_cs_a,
  input             spi_cs_b,

  // microprocessor interface (control)

  input             reset_a,
  input             reset_b,
  input             sync_in,

  // microprocessor interface (comms)

  input             ebi_nrde,
  output  [ 15:0]   ebi_data,
  output            ebi_ready

);

  // internal signals

  wire              rd_clk;
  wire              wr_clk;

  wire              rd_ena;

  wire              a_data_clk;
  wire              b_data_clk;

  wire              samp_valid;
  wire              samp_ready;
  wire    [127:0]   samp_data;

  // clock generation

  anchor_clk_gen #()
  anchor_clk_gen (
    .clk (a_data_clk),
    .rd_clk (rd_clk),
    .wr_clk (wr_clk)
  );

  // synchronize external signals

  xpm_cdc_single #(
    .DEST_SYNC_FF (2),
    .SRC_INPUT_REG (0)
  ) xpm_cdc_single_nrde (
    .src_in (~ebi_nrde),
    .dest_clk (rd_clk),
    .dest_out (rd_ena)
  );

  // dual-9361 controller

  ad9361_dual #(
    .DEVICE_TYPE ("7SERIES"),
    .REALTIME_ENABLE (1),
    .USE_SAMPLE_FILTER (1),
    .NUM_PAD_SAMPS (31),
    .DATA_PASS_VALUE (64),
    .FILTER_LENGTH (16),
    .SAMPS_WIDTH (128),
    .PRECISION (12),
    .REVERSE_DATA (0),
    .INDEP_CLOCKS (0),
    .USE_AXIS_TLAST (0)
  ) ad9361_dual (
    .clk (wr_clk),
    .a_rx_clk_in (a_rx_clk_in),
    .a_rx_frame_in (a_rx_frame_in),
    .a_rx_data_p0 (a_rx_data_p0),
    .a_rx_data_p1 (a_rx_data_p1),
    .b_rx_clk_in (b_rx_clk_in),
    .b_rx_frame_in (b_rx_frame_in),
    .b_rx_data_p0 (b_rx_data_p0),
    .b_rx_data_p1 (b_rx_data_p1),
    .a_data_clk (a_data_clk),
    .a_resetb (a_resetb),
    .a_enable (a_enable),
    .a_txnrx (a_txnrx),
    .b_data_clk (b_data_clk),
    .b_resetb (b_resetb),
    .b_enable (b_enable),
    .b_txnrx (b_txnrx),
    .a_spi_sck (a_spi_sck),
    .a_spi_di (a_spi_di),
    .a_spi_do (a_spi_do),
    .a_spi_cs (a_spi_cs),
    .b_spi_sck (b_spi_sck),
    .b_spi_di (b_spi_di),
    .b_spi_do (b_spi_do),
    .b_spi_cs (b_spi_cs),
    .reset_a (reset_a),
    .reset_b (reset_b),
    .spi_sck (spi_sck),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_cs_a (spi_cs_a),
    .spi_cs_b (spi_cs_b),
    .m_axis_clk (wr_clk),
    .m_axis_tvalid (samp_valid),
    .m_axis_tready (samp_ready),
    .m_axis_tlast (),
    .m_axis_tdata (samp_data)
  );

  assign sync_out = sync_in;

  // sample buffer

  buf_samp_data #(
    .FIFO_DEPTH (65536),
    .WRITE_WIDTH (128),
    .READ_WIDTH (16)
  ) buf_samp_data (
    .wr_clk (wr_clk),
    .rd_clk (rd_clk),
    .s_axis_tvalid (samp_valid),
    .s_axis_tready (samp_ready),
    .s_axis_tdata (samp_data),
    .rd_ena (rd_ena),
    .rd_ready (ebi_ready),
    .rd_data (ebi_data)
  );

endmodule
