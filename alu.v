module alu( 
           //Input signals
           input            clk,
           input            reset,
           input            valid_in,    //validate input signals
           input [3:0]      a,           //port A
           input [3:0]      b,           //port B 
           input            cin,         //carry input from carry flag register 
           input [3:0]      ctl,         //functionality control for ALU 
           //Output signals
           output reg       valid_out,   //validate output signals
           output reg [3:0] alu,         //the result 
           output reg       carry,       //carry output 
           output reg       zero         //zero output 
           );

//Internal signals
wire [4:0] result; // ALU result
wire       zero_result;

reg valid_out_R;
assign result = alu_out(a,b,cin,ctl); 
assign zero_result = z_flag(result); 


always@(posedge clk, negedge reset) begin
  if(reset == 0) begin
    valid_out_R <= 0;
    valid_out   <= 0;
    alu         <= 0;
    carry       <= 0; 
    zero        <= 0;
  end
  else begin
    //Internal register
    valid_out_R <= valid_in;

    //Valid_out logic
    if(ctl == 4'b1001) begin       //[BUG]
      valid_out <= ~valid_in;
    end
    else if(ctl == 4'b0110) begin  //[BUG]
      valid_out <= valid_out_R;
    end
    else begin
      valid_out <= valid_in;
    end

    //Other outputs logic
    if(valid_in) begin
      alu   <= result[3:0]; 
      carry <= result[4]; 
      zero  <= zero_result; 
    end

  end//else

end//always

function [4:0] alu_out; 
input [3:0] a,b ; 
input cin ; 
input [3:0] ctl ; 
case ( ctl ) 
4'b0000: alu_out=a;                                //Select data on port B [BUG]
4'b0001: alu_out=b+4'b0001 ;                       //Increment data on port B 
4'b0010: alu_out=b-4'b0001 ;                       //Decrement data on port B 
4'b0011: alu_out=a+b;                              //ADD without CARRY 
4'b0100: alu_out=a+b+cin;                          //ADD with CARRY 
4'b0101: alu_out=a-b+1 ;                           //SUB without BORROW[BUG] 
4'b0110: alu_out=a-b+(~cin);                       //SUB with BORROW 
4'b0111: alu_out=a&b;                              //AND 
4'b1000: alu_out=a|b;                              //OR 
4'b1001: alu_out=a^b;                              //XOR 
4'b1010: alu_out={b[3:0],1'b1};                    //Shift Left[BUG] 
4'b1011: alu_out={b[0],1'b0,b[3:1]};               //Shift Right 
4'b1100: alu_out={b[3:0],cin};                     //Rotate Left 
4'b1101: alu_out={b[0],cin,b[3:1]};                //Rotate Right 
default : begin 
alu_out=9'bxxxxxxxxx; 
$display("Illegal CTL detected!!"); 
end 
endcase /* {...,...,...} is for the concatenation. 
{ADD_WITH_CARRY,SUB_WITH_BORROW}==2'b11 is used 
to force the CARRY==1 for the increment operation */ 
endfunction // end of function "result" 

function z_flag ; 
input [4:0] a4 ; 
begin 
z_flag = ^(a4[0]|a4[1]|a4[2]|a4[3]) ; // zero flag check for a4 
end 
endfunction 

endmodule