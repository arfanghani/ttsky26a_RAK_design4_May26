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
    // PROGRAM MEMORY
    // =========================
    reg [7:0] mem [0:31];
    reg [7:0] mem_dump [0:31];
    integer i;

    // =========================
    // CPU STATE (IMPORTANT: INIT TO AVOID X)
    // =========================
    reg [4:0] pc;
    reg [7:0] instr;
    reg [7:0] R0, R1, R2, R3;

    wire [7:0] fetched;
    wire [3:0] opcode;

    assign fetched = mem[pc];
    assign opcode  = instr[7:4];

    // =========================
    // MEMORY INITIALIZATION
    // =========================
    initial begin
        pc = 0;
        instr = 0;
        R0 = 0; R1 = 0; R2 = 0; R3 = 0;

        mem[0] = 8'h10;
        mem[1] = 8'h20;
        mem[2] = 8'h30;
        mem[3] = 8'h40;
        mem[4] = 8'h00;

        for (i = 5; i < 32; i = i + 1)
            mem[i] = 8'h00;

        for (i = 0; i < 32; i = i + 1)
            mem_dump[i] = 0;
    end

    // =========================
    // CPU CORE
    // =========================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc    <= 0;
            instr <= 0;
            R0    <= 0;
            R1    <= 0;
            R2    <= 0;
            R3    <= 0;

        end else if (ena) begin

            // safe fetch (pc is always valid due to reset)
            instr <= fetched;

            // safe PC loop
            if (pc >= 5'd4)
                pc <= 0;
            else
                pc <= pc + 1;

            // execute
            case (opcode)
                4'h1: R0 <= R0 + 1;
                4'h2: R1 <= R1 + 1;
                4'h3: R2 <= R2 + 1;
                4'h4: R3 <= R3 + 1;
                default: ;
            endcase

            // snapshot memory for waveform
            for (i = 0; i < 32; i = i + 1)
                mem_dump[i] <= mem[i];
        end
    end

    // =========================
    // DEBUG OUTPUT
    // =========================
    always @(*) begin
        case (ui_in[4:3])
            2'b00: uo_out = pc;
            2'b01: uo_out = instr;
            2'b10: uo_out = R0;
            2'b11: uo_out = R1;
        endcase
    end

    assign uio_out = 8'h00;
    assign uio_oe  = 8'h00;

endmodule

`default_nettype wire
