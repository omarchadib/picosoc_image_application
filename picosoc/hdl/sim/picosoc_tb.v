`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Omar Chadib
// 
// 
// Create Date: 05/31/2024 11:03:40 AM
// Design Name: 
// Module Name: picosoc_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module picosoc_tb;

    // Clock and Reset Signals
    reg clk;
    reg resetn;

    // IO Memory Signals
    wire iomem_valid;
    reg  iomem_ready;
    wire [3:0] iomem_wstrb;
    wire [31:0] iomem_addr;
    wire [31:0] iomem_wdata;
    reg [31:0] iomem_rdata;

    // IRQ Signals
    reg irq_5;
    reg irq_6;
    reg irq_7;

    // UART Signals
    wire ser_tx;
    reg  ser_rx;

    // Instantiate the Unit Under Test (UUT)
    picosoc uut (
        .clk(clk),
        .resetn(resetn),
        .iomem_valid(iomem_valid),
        .iomem_ready(iomem_ready),
        .iomem_wstrb(iomem_wstrb),
        .iomem_addr(iomem_addr),
        .iomem_wdata(iomem_wdata),
        .iomem_rdata(iomem_rdata),
        .irq_5(irq_5),
        .irq_6(irq_6),
        .irq_7(irq_7),
        .ser_tx(ser_tx),
        .ser_rx(ser_rx)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Testbench Initialization
    initial begin
        // Initialize Inputs
        resetn = 0;
        iomem_ready = 0;
        iomem_rdata = 0;
        irq_5 = 0;
        irq_6 = 0;
        irq_7 = 0;
        ser_rx = 0;

        // Wait for global reset to finish
        #100;
        resetn = 1;

        // Apply test stimuli
        #100;
        irq_5 = 1;
        #20;
        irq_5 = 0;

        #100;
        iomem_ready = 1;
        iomem_rdata = 32'hDEADBEEF;

        #100;
        iomem_ready = 0;

        
    end

    // Monitor
    initial begin
        $monitor("At time %t, iomem_valid = %b, iomem_addr = %h, iomem_wdata = %h, iomem_rdata = %h",
                 $time, iomem_valid, iomem_addr, iomem_wdata, iomem_rdata);
    end

    // End simulation
    initial begin
        #1000;
        $finish;
    end

endmodule