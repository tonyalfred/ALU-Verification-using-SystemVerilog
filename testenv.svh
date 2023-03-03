/* Test Environment */

// includes all environment components:
// Driver, Stimulus, Monitor, Scoreboard.
// The objects creation and running for all components starts from here

`include "alu_if.sv"
import env_pkg::*;

class test_env;

mailbox    s2d_mb            ;
mailbox    log_mon, log_stim ;

driver     alu_drv           ;
monitor    alu_mon           ;

scoreboard sb                ;
stimulus   s                 ;

// virtual interface 
virtual alu_if vif           ; 

function new(virtual alu_if vif, int fd);
	// create scoreboard & configure feeding mailbox handles
	// create the monitor, driver and stimulus objects
	this.vif = vif;

	s2d_mb = new();
	log_mon = new();
	log_stim = new();

	s = new (s2d_mb,log_stim); 
	alu_drv = new (vif,s2d_mb);
	alu_mon = new (vif,log_mon);
	sb = new (log_mon, log_stim, fd);
endfunction

task run();
// start everything
	fork
		s.stim_task(100); // number of trans
		alu_drv.driver_task();
		alu_mon.monitor_task();
		sb.sb_task();
	join 
	$finish;
endtask
endclass : test_env