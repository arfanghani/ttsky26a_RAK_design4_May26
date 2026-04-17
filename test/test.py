import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def cpu_test(dut):

    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())

    # --------------------
    # INIT
    # --------------------
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # --------------------
    # RESET
    # --------------------
    dut.rst_n.value = 0
    for _ in range(5):
        await RisingEdge(dut.clk)

    dut.rst_n.value = 1

    for _ in range(5):
        await RisingEdge(dut.clk)

    # --------------------
    # RUN CPU
    # --------------------
    for i in range(80):

        await RisingEdge(dut.clk)

        pc = int(dut.uio_out.value)  # ONLY if you exposed PC
        dut._log.info(f"cycle={i} PC={pc}")
