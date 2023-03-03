/* Scoreboard */

// Scoreboard receives the sampled packet from the monitor and compare with the expected result
// error will be reported if the comparison results in a mismatch.
// Scoreboard receives the sampled packet from the monitor and compare with the expected result
// error will be reported if the comparison results in a mismatch.

class scoreboard;

  packet  pkt_mon;
  packet  pkt_stim;
  
  mailbox log_mon;
  mailbox log_stim;
  
	// Indices to help order bugs found
	int bug_num = 1    ;
	int ERROR_FLAG = 0 ;

  // file handle to export bugs found in
	int fd;

  function new(mailbox log_mon, mailbox log_stim, int fd);
    this.log_mon  = log_mon  ;
    this.log_stim = log_stim ;
    this.fd       = fd       ;
  endfunction

  task sb_task;
    forever begin

      pkt_mon  = new();
      pkt_stim = new();

      log_mon.get(pkt_mon);
      log_stim.get(pkt_stim);  

      if (pkt_stim.valid_in) begin
        pkt_stim.valid_out = 1'b1;
        pkt_stim.carry = 1'b0;
		
        case (pkt_stim.ctl)

          4'b0000: pkt_stim.alu = pkt_stim.b;  //Select data on port B
          4'b0001:
          {pkt_stim.carry, pkt_stim.alu} = pkt_stim.b + 4'b0001;  //Increment data on port B 
          4'b0010:
          {pkt_stim.carry, pkt_stim.alu} = pkt_stim.b - 4'b0001;  //Decrement data on port B 
          4'b0011: {pkt_stim.carry, pkt_stim.alu} = pkt_stim.a + pkt_stim.b;  //ADD without CARRY 
          4'b0100:
          {pkt_stim.carry,pkt_stim.alu}=pkt_stim.a+pkt_stim.b+pkt_stim.cin; 		//ADD with CARRY 
          4'b0101: begin
            pkt_stim.alu   = pkt_stim.a - pkt_stim.b;
            pkt_stim.carry = (pkt_stim.a < pkt_stim.b) ? 1'b1 : 1'b0;
          end  //SUB without BORROW 
          4'b0110: begin
            pkt_stim.alu   = pkt_stim.a - pkt_stim.b + (~pkt_stim.cin);
			if (pkt_stim.b<15) 
            pkt_stim.carry = (pkt_stim.a < pkt_stim.b + 1'b1) ? 1'b1 : 1'b0;
            else
            pkt_stim.carry = 1'b1;
          end  //SUB with BORROW 
          4'b0111: pkt_stim.alu = pkt_stim.a & pkt_stim.b;  //AND 
          4'b1000: pkt_stim.alu = pkt_stim.a | pkt_stim.b;  //OR 
          4'b1001: pkt_stim.alu = pkt_stim.a ^ pkt_stim.b;  //XOR 
          4'b1010: begin
            pkt_stim.alu   = {pkt_stim.b << 1};  //Shift Left 
            pkt_stim.carry = pkt_stim.b[3];
          end
          4'b1011: begin
            pkt_stim.alu   = {1'b0, pkt_stim.b[3:1]};
            pkt_stim.carry = pkt_stim.b[0];
          end  //Shift Right 
          4'b1100: begin
            pkt_stim.alu   = {pkt_stim.b[2:0], pkt_stim.cin};
            pkt_stim.carry = pkt_stim.b[3];
          end  //Rotate Left 
          4'b1101: begin
            pkt_stim.alu   = {pkt_stim.cin, pkt_stim.b[3:1]};
            pkt_stim.carry = pkt_stim.b[0];  //Rotate Right 
          end
          default: begin
            pkt_stim.alu = 4'bxxxx;
			pkt_stim.carry = 1'bx;
			pkt_stim.zero = 1'bx;
            $display("SCOREBOARD ILLEGAL CASE!");
          end
        endcase

       if(pkt_stim.ctl<14 && pkt_stim.valid_in)
        pkt_stim.zero = ~(pkt_stim.alu === 0);

      end 
	  else begin
        pkt_stim.alu 		= 4'bz;
        pkt_stim.valid_out 	= 1'b0;
		pkt_stim.carry 		= 1'bz;
		pkt_stim.zero 		= 1'bz;
		
        $display("INPUT NOT VALID");
        $fdisplay (fd, "INPUT NOT VALID    :") ;
      end

      $display("packet_mon = %p" , pkt_mon ) ;
      $display("packet_stim = %p", pkt_stim) ;

      // CHECK ALL OUTPUTS TO BE MATCHED
      if (pkt_mon.alu === pkt_stim.alu && pkt_mon.carry === pkt_stim.carry && pkt_mon.zero === pkt_stim.zero && pkt_stim.valid_out === pkt_mon.valid_out) 
        $display("TEST PASSED!");
        
      else 
        begin
        ERROR_FLAG  =  0  ;
        if (pkt_mon.alu !== pkt_stim.alu)
          begin
            ERROR_FLAG  =  1                 ;
            $display  ("RESULT ERROR     :") ;
            $fdisplay (fd, "RESULT ERROR     :") ;
          end
        if (pkt_mon.carry !== pkt_stim.carry) 
          begin
            ERROR_FLAG  =  1                 ;
            $display  ("CARRY FLAG ERROR :") ;
            $fdisplay (fd, "CARRY FLAG ERROR :") ;
          end
        if (pkt_mon.zero !== pkt_stim.zero)
          begin
            ERROR_FLAG  =  1                 ;
            $display  ("ZERO FLAG ERROR  :") ;
            $fdisplay (fd, "ZERO FLAG ERROR  :") ;
          end
        if (pkt_mon.valid_out !== pkt_stim.valid_out) 
          begin
            ERROR_FLAG  =  1                 ;
            $display  ("VALID_OUT ERROR  :") ;
            $fdisplay (fd, "VALID_OUT ERROR  :") ;
          end 
        if (ERROR_FLAG == 1)
          begin
            $fdisplay (fd, "BUG NUMBER    : %d", bug_num ) ;
            $fdisplay (fd, "MODEL PACKET  : %p", pkt_stim) ;
            $fdisplay (fd, "DUT   PACKET  : %p", pkt_mon ) ;
            $fdisplay (fd, "-----------------------------------") ;
            bug_num ++                                     ; 
          end
      end
    end
  endtask
endclass