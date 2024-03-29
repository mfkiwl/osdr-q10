////////////////////////////////////////////////////////////////////////////////
// Company: 奥新智能
// Engineer: Frank Liu
//
// Description: Verilog function, base-2 logarithm.
//
////////////////////////////////////////////////////////////////////////////////

function integer log2;
  input integer size;
  begin
    for (log2 = 0; size > 0; log2 = log2 + 1) begin
      size = size >> 1;
    end
  end
endfunction
