# ALU-Verification-using-SystemVerilog
Build a SystemVerilog Environment for an ALU, including all OOP Testbench components as; stimulus generator, driver, monitor, scoreboard. RTL and TB was tested using QuestaSim.

• ALU Block Diagram:

![ALU_diagram_ss](https://user-images.githubusercontent.com/82821323/222882349-e7790ca0-064c-4635-a71a-7fe104287974.jpg)

• ALU Specifications:

![ALU_specs](https://user-images.githubusercontent.com/82821323/222882469-c74d2e7b-b1b1-47b1-a922-0e8815694da6.jpg)

• ALU Testbench Architecture:

![ALU_tb_arch](https://user-images.githubusercontent.com/82821323/222882528-9f3a536d-9b11-440e-83d6-b4b998cf8c75.jpg)

• Project Workings:

after including the SV files in a project, and simulating the top module, the tb automatically prints out the bugs/mismatches between RTL and tb in a file within the same directory of the project, called "bugs.txt".
