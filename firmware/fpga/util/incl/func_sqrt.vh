////////////////////////////////////////////////////////////////////////////////
// Company: 奥新智能
// Engineer: Frank Liu
//
// Description: Verilog function, integer square root.
//
////////////////////////////////////////////////////////////////////////////////

function integer sqrt;
  input integer size;
  begin
    sqrt = 0;
    while (sqrt * sqrt < size) begin
       sqrt = sqrt + 1;
    end
  end
endfunction
