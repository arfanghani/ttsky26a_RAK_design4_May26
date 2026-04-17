`default_nettype none

module tt_um_nano_cpu_p (
    input  wire [7:0] ui_in,
    output reg  [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire ena,
    input  wire clk,
    input  wire rst_n
);

    // =========================
    // ROM (PROGRAM MEMORY)
    // =========================
    reg [7:0] rom [0:31];
    integer i;

    initial begin
        rom[0] = 8'h10;
        rom[1] = 8'h20;
        rom[2] = 8'h30;
        rom[3] = 8'h40;
        rom[4] = 8'h00;

        for (i = 5; i < 32; i = i + 1)
            rom[i] = 8'h00;
    end

    // =========================
    // RAM (VISIBLE IN GTKWAVE)
    // =========================
    reg [7:0] ram [0:31];
    integer j;

    initial begin
        for (j = 0; j < 32; j = j + 1)
            ram[j] = 8'h00;
    end

    // =========================
    // CPU STATE
    // =========================
    reg [4:0] pc;
    reg [7:0] instr;

    reg [7:0] R0, R1, R2, R3;

    wire [3:0] opcode = instr[7:4];
    wire [4:0] ram_addr = ui_in[4:0];

    // =========================
    // FETCH
    // =========================
    wire [7:0] fetched = rom[pc];

    // =========================
    // EXECUTE
    // =========================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc    <= 0;
            instr <= 0;
            R0 <= 0; R1 <= 0; R2 <= 0; R3 <= 0;
        end else if (ena) begin

            instr <= fetched;

            // safe loop
            if (pc == 4)
                pc <= 0;
            else
                pc <= pc + 1;

            case (opcode)
                4'h1: R0 <= R0 + 1;
                4'h2: R1 <= R1 + 1;
                4'h3: R2 <= R2 + 1;
                4'h4: R3 <= R3 + 1;
                default: ;
            endcase

            // OPTIONAL RAM WRITE (student feature)
            if (ui_in[7]) begin
                ram[ram_addr] <= ui_in;
            end
        end
    end

    // =========================
    // DEBUG OUTPUT MUX
    // =========================
    always @(*) begin
        case (ui_in[6:5])
            2'b00: uo_out = pc;
            2'b01: uo_out = instr;
            2'b10: uo_out = R0;
            2'b11: uo_out = ram[ram_addr];
        endcase
    end

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule

`default_nettype wire
