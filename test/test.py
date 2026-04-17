import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

def safe_int(sig):
    val = sig.value
    if "x" in val.binstr.lower() or "z" in val.binstr.lower():
        return 0
    return val.integer

@cocotb.test()
async def cpu_test(dut):

    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    dut.ena.value = 1

    await RisingEdge(dut.clk)
    dut.rst_n.value = 1

    for _ in range(120):

        await RisingEdge(dut.clk)

        pc = safe_int(dut.uio_out)

        dut._log.info(f"PC={pc}")
