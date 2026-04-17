`timescale 1ns/1ps
`default_nettype none

module tb;

    reg clk;
    reg rst_n;
    reg ena;
    reg [7:0] ui_in;
    reg [7:0] uio_in;

    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    tt_um_nano_cpu_p dut (
        .ui_in(ui_in),
        .uio_in(uio_in),
        .uo_out(uo_out),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    always #10 clk = ~clk;

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        clk = 0;
        ena = 1;
        rst_n = 0;
        ui_in = 0;
        uio_in = 0;

        repeat(5) @(posedge clk);
        rst_n = 1;

        // Program a tiny loop:
        // LOADI R0,1
        // ADD R0,R0
        // JMP 0

        ui_in[2] = 1; // program mode
        ui_in[1] = 1; // write enable
        ui_in[0] = 1; // serial bit (dummy demo stream)

        repeat(10) @(posedge clk);

        ui_in[2] = 0; // run mode
        ui_in[1] = 0;

        repeat(100) @(posedge clk);

        $finish;
    end

endmodule
