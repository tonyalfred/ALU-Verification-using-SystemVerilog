/* Driver */ 

// receive the stimulus generated from the generator and drive to DUT 
// by assigning transaction class values to interface signals.

class driver;
	
	virtual alu_if vif ;
	mailbox s2d_mb     ;
	packet pkt         ;
	 
	function new(virtual alu_if vif , mailbox s2d_mb );
		this.vif 	= vif;
		this.s2d_mb = s2d_mb;
	endfunction
	
	task driver_task();
		forever
		begin

		s2d_mb.peek(pkt);
	
		@(posedge vif.clk);
		begin
		vif.a 			  <= pkt.a 	      ;
		vif.b 			  <= pkt.b 	      ;
		vif.valid_in 	<= pkt.valid_in ;
		vif.cin 		  <= pkt.cin 	    ;
		vif.ctl 		  <= pkt.ctl	    ;
		vif.pkt_num   <= pkt.pkt_num  ;
 		end

		//output 
		@(posedge vif.clk)
		begin
		pkt.alu 	   	= vif.alu 	    ;
		pkt.valid_out = vif.valid_out ;
		pkt.carry 		= vif.carry    	;
		pkt.zero 		  = vif.zero 	    ;
		end

		s2d_mb.get(pkt);
		$display("packet_driver = %p",pkt)	;	
		end 
	endtask 
endclass