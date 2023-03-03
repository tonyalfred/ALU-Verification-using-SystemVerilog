/* Top */

`include "testenv.svh"

module top;

    import env_pkg::*;

    parameter clock_cycle = 100 ;

    logic     SystemClock       ;
    logic     SystemReset       ;

    // External File Handle
    int fd;

    // Reset Generation
    task reset();
    endtask

    alu_if top_if(SystemClock, SystemReset);

    // DUT Instantiation
    alu DUT(
    .clk       (SystemClock)      ,   
    .reset     (SystemReset)      ,
    .valid_in  (top_if.valid_in)  ,
    .a         (top_if.a)         , 
    .b         (top_if.b)         ,  
    .cin       (top_if.cin)       ,  
    .ctl       (top_if.ctl)       ,
    .valid_out (top_if.valid_out) , 
    .alu       (top_if.alu)       ,
    .carry     (top_if.carry)     , 
    .zero      (top_if.zero)
    );

    // Test Environment Instantiation
    test_env t_env;

    // Clock Initialization 
    initial begin
        SystemClock = 0;
    end

    // Clock Generation
    always #5 SystemClock = ~ SystemClock ;

    initial begin
        reset();
        // open file to print out in the bugs found and their type
        fd = $fopen ("./bugs.txt", "w");

        // create test environment
        t_env = new(top_if, fd); 

        // get things running
        t_env.run (); 
    end
endmodule