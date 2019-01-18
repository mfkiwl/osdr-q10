////////////////////////////////////////////////////////////////////////////////
// Company: 奥新智能
// Engineer: 耿慧慧
//
// Description: A fast base-2 logarithm function
//
// Revision: N/A
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

module math_log2_32 (

  // core interface

  input                    clk,
  input                    rst,
  input                    ena,

  // data interface

  input     [31:0]         din,
  output    [ 8:0]         dout

);

  // Comprises 3 main blocks: priority encoder, barrel shifter, and LUT

  reg       [ 4:0]         priencout1 = 'b0;
  reg       [ 3:0]         lut_out = 'b0;
  reg       [ 3:0]         lut_out_reg = 'b0;
  reg       [ 4:0]         priencout2 = 'b0;
  reg       [ 4:0]         priencout3 = 'b0;
  reg       [27:0]         barrelin = 'b0;
  reg       [ 4:0]         barrelout = 'b0;

  assign dout =	{priencout3, lut_out};	// Basic top-level connectivity

  // Barrel shifter - OMG, it's a primitive in Verilog!

  wire      [31:0]         priencin = din[31:0];
  wire      [27:0]         tmp1 = (barrelin << ~priencout1);

  always @(posedge clk) begin
    if (rst) begin
      barrelout <= 'b0;
    end else if (ena) begin
      barrelout <= tmp1[27:23];
    end
  end

  // Priority encoder

  always @(posedge clk) begin
    if (rst) begin
      priencout2 <= 'b0;
      priencout3 <= 'b0;
      barrelin <= 'b0;
    end else if (ena) begin
      priencout2 <= priencout1;
      priencout3 <= priencout2;
      barrelin <= din[30:3];
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      priencout1 <= 0;
    end else if (ena) begin
      casez (priencin)
       
        32'b1???????????????????????????????: priencout1 <= 31;
        32'b01??????????????????????????????: priencout1 <= 30;
        32'b001?????????????????????????????: priencout1 <= 29;
        32'b0001????????????????????????????: priencout1 <= 28;
        32'b00001???????????????????????????: priencout1 <= 27;
        32'b000001??????????????????????????: priencout1 <= 26;
        32'b0000001?????????????????????????: priencout1 <= 25;
        32'b00000001????????????????????????: priencout1 <= 24;
        32'b000000001???????????????????????: priencout1 <= 23;
        32'b0000000001??????????????????????: priencout1 <= 22;
        32'b00000000001?????????????????????: priencout1 <= 21;
        32'b000000000001????????????????????: priencout1 <= 20;
        32'b0000000000001???????????????????: priencout1 <= 19;
        32'b00000000000001??????????????????: priencout1 <= 18;
        32'b000000000000001?????????????????: priencout1 <= 17;
        32'b0000000000000001????????????????: priencout1 <= 16;
        32'b00000000000000001???????????????: priencout1 <= 15;
        32'b000000000000000001??????????????: priencout1 <= 14;
        32'b0000000000000000001?????????????: priencout1 <= 13;
        32'b00000000000000000001????????????: priencout1 <= 12;
        32'b000000000000000000001???????????: priencout1 <= 11;
        32'b0000000000000000000001??????????: priencout1 <= 10;
        32'b00000000000000000000001?????????: priencout1 <= 9;
        32'b000000000000000000000001????????: priencout1 <= 8;
        32'b0000000000000000000000001???????: priencout1 <= 7;
        32'b00000000000000000000000001??????: priencout1 <= 6;
        32'b000000000000000000000000001?????: priencout1 <= 5;
        32'b0000000000000000000000000001????: priencout1 <= 4;
        32'b00000000000000000000000000001???: priencout1 <= 3;
        32'b000000000000000000000000000001??: priencout1 <= 2;
        32'b0000000000000000000000000000001?: priencout1 <= 1;
        32'b0000000000000000000000000000000?: priencout1 <= 0;
        default : priencout1 <= 0;
      endcase
    end
  end

  /*
  LUT for log fraction lookup
   - can be done with array or case:

  case (addr)
  0:out=0;
  .
  31:out=15;
  endcase

  	OR

  wire [3:0] lut [0:31];
  assign lut[0] = 0;
  .
  assign lut[31] = 15;

  Are there any better ways?
  */

  // Let's try "case".
  // The equation is: output = log2(1+input/32)*16
  // For larger tables, better to generate a separate data file using a program!

 /* always @*
    case (barrelout)

      0 : lut_out = 0;
      1 : lut_out = 0;
      2 : lut_out = 1;
      3 : lut_out = 2;
      4 : lut_out = 2;
      5 : lut_out = 3;
      6 : lut_out = 4;
      7 : lut_out = 4;
      8 : lut_out = 5;
      9 : lut_out = 6;
      10: lut_out = 6;
      11: lut_out = 7;
      12: lut_out = 7;
      13: lut_out = 8;
      14: lut_out = 9;
      15: lut_out = 9;
      16: lut_out = 10;
      17: lut_out = 10;
      18: lut_out = 11;
      19: lut_out = 12;
      20: lut_out = 12;
      21: lut_out = 13;
      22: lut_out = 13;
      23: lut_out = 14;
      24: lut_out = 14;
      25: lut_out = 15;
      26: lut_out = 15;
      27: lut_out = 16;
      28: lut_out = 16;	// calculated value is *slightly* closer to 15, but 14 makes for a smoother curve!
      29: lut_out = 17;
      30: lut_out = 17;
      31: lut_out = 18;
      32: lut_out = 18;
      33: lut_out = 19;
      34: lut_out = 19;
      35: lut_out = 20;
      36: lut_out = 20;
      37: lut_out = 21;
      38: lut_out = 21;
      39: lut_out = 21;
      40: lut_out = 22;
      41: lut_out = 22;
      42: lut_out = 23;
      43: lut_out = 23;
      44: lut_out = 24;
      45: lut_out = 24;
      46: lut_out = 25;
      47: lut_out = 25;
      48: lut_out = 25;
      49: lut_out = 26;
      50: lut_out = 26;
      51: lut_out = 27;
      52: lut_out = 27;
      53: lut_out = 27;
      54: lut_out = 28;
      55: lut_out = 28;
      56: lut_out = 29;
      57: lut_out = 29;
      58: lut_out = 29;
      59: lut_out = 30;
      60: lut_out = 30;    // calculated value is *slightly* closer to 15, but 14 makes for a smoother curve!
      61: lut_out = 30;
      62: lut_out = 31;
      63: lut_out = 31;
    endcase */

 // The equation is: output = log2(1+input/32)*16

  always @(posedge clk) begin
    if (rst) begin
      lut_out <= 0;
    end else if (ena) begin
      case (barrelout)
        0 : lut_out <= 0;
        1 : lut_out <= 1;
        2 : lut_out <= 1;
        3 : lut_out <= 2;
        4 : lut_out <= 3;
        5 : lut_out <= 3;
        6 : lut_out <= 4;
        7 : lut_out <= 5;
        8 : lut_out <= 5;
        9 : lut_out <= 6;
        10: lut_out <= 6;
        11: lut_out <= 7;
        12: lut_out <= 7;
        13: lut_out <= 8;
        14: lut_out <= 8;
        15: lut_out <= 9;
        16: lut_out <= 9;
        17: lut_out <= 10;
        18: lut_out <= 10;
        19: lut_out <= 11;
        20: lut_out <= 11;
        21: lut_out <= 12;
        22: lut_out <= 12;
        23: lut_out <= 13;
        24: lut_out <= 13;
        25: lut_out <= 13;
        26: lut_out <= 14;
        27: lut_out <= 14;
        28: lut_out <= 14;
        29: lut_out <= 15;
        30: lut_out <= 15;
        31: lut_out <= 15;
        default : lut_out <= 0;
      endcase
    end
  end

endmodule

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////