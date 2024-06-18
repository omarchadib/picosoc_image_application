`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2024 02:30:45 PM
// Design Name: 
// Module Name: picosc2_tb
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


module picosoc2_tb;

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

    // Flash Signals (Sorties)
    wire flash_csb;
    wire flash_clk;
    wire flash_io0_oe;
    wire flash_io1_oe;
    wire flash_io2_oe;
    wire flash_io3_oe;
    wire flash_io0_do;
    wire flash_io1_do;
    wire flash_io2_do;
    wire flash_io3_do;
    // Flash Signals (Entrées)
    reg flash_io0_di;
    reg flash_io1_di;
    reg flash_io2_di;
    reg flash_io3_di;

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
        .ser_rx(ser_rx),
        .flash_csb(flash_csb),
        .flash_clk(flash_clk),
        .flash_io0_oe(flash_io0_oe),
        .flash_io1_oe(flash_io1_oe),
        .flash_io2_oe(flash_io2_oe),
        .flash_io3_oe(flash_io3_oe),
        .flash_io0_do(flash_io0_do),
        .flash_io1_do(flash_io1_do),
        .flash_io2_do(flash_io2_do),
        .flash_io3_do(flash_io3_do),
        .flash_io0_di(flash_io0_di),
        .flash_io1_di(flash_io1_di),
        .flash_io2_di(flash_io2_di),
        .flash_io3_di(flash_io3_di)
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