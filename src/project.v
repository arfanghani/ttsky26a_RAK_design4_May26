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
    // PROGRAM MEMORY (ROM)
    // =========================
    reg [7:0] mem [0:31];
    integer i;

    initial begin
        mem[0] = 8'h10;
        mem[1] = 8'h20;
        mem[2] = 8'h30;
        mem[3] = 8'h40;
        mem[4] = 8'h00;

        for (i = 5; i < 32; i = i + 1)
            mem[i] = 8'h00;
    end

    // =========================
    // CPU STATE
    // =========================
    reg [4:0] pc;
    reg [7:0] instr;

    reg [7:0] R0, R1, R2, R3;

    // Fetch + decode
    wire [7:0] fetched = mem[pc];
    wire [3:0] opcode  = fetched[7:4];

    // =========================
    // CPU CORE
    // =========================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc    <= 0;
            instr <= 0;
            R0 <= 0; R1 <= 0; R2 <= 0; R3 <= 0;

        end else if (ena) begin

            // fetch
            instr <= fetched;

            // execute
            case (opcode)
                4'h1: R0 <= R0 + 1;
                4'h2: R1 <= R1 + 1;
                4'h3: R2 <= R2 + 1;
                4'h4: R3 <= R3 + 1;
                default: ;
            endcase

            // PC update
            pc <= (pc == 4) ? 0 : pc + 1;

        end
    end

    // =========================
    // DEBUG OUTPUT SELECT
    // =========================
    always @(*) begin
        case (ui_in[4:3])
            2'b00: uo_out = pc;
            2'b01: uo_out = instr;
            2'b10: uo_out = R0;
            2'b11: uo_out = R1;
        endcase
    end

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule

`default_nettype wire
