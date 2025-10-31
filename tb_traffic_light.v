`timescale 1ns/1ps
module tb_traffic_light;
    reg clk, reset;
    wire [2:0] light;

    // Instantiate design
    traffic_light_controller dut(clk, reset, light);

    // Clock generation
    always #5 clk = ~clk; // 10ns period

    initial begin
        $dumpfile("traffic_light.vcd");
      $dumpvars(1, tb_traffic_light);

        // Initialize
        clk = 0; reset = 1;
        #10 reset = 0;

        // Run simulation
        #200 $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time=%0t | RED=%b YELLOW=%b GREEN=%b",
                 $time, light[2], light[1], light[0]);
    end
endmodule
