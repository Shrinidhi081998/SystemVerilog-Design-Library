// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vsync_fifo__Syms.h"


void Vsync_fifo___024root__trace_chg_0_sub_0(Vsync_fifo___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vsync_fifo___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root__trace_chg_0\n"); );
    // Body
    Vsync_fifo___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vsync_fifo___024root*>(voidSelf);
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    Vsync_fifo___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vsync_fifo___024root__trace_chg_dtype____0(Vsync_fifo___024root* vlSelf, VerilatedVcd::Buffer* bufp, uint32_t offset, const VlUnpacked<CData/*7:0*/, 16>& __VdtypeVar);

void Vsync_fifo___024root__trace_chg_0_sub_0(Vsync_fifo___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root__trace_chg_0_sub_0\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 0);
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[1U]))) {
        bufp->chgCData(oldp+0,(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__mem
                               [(0x0000000fU & (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__rptr))]),8);
        bufp->chgBit(oldp+1,(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__full));
        bufp->chgBit(oldp+2,(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__empty));
        Vsync_fifo___024root__trace_chg_dtype____0(vlSelf, bufp, 3, vlSelfRef.tb_sync_fifo__DOT__dut__DOT__mem);
        bufp->chgCData(oldp+19,(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__rptr),5);
    }
    bufp->chgBit(oldp+20,(vlSelfRef.tb_sync_fifo__DOT__clk));
    bufp->chgBit(oldp+21,(vlSelfRef.tb_sync_fifo__DOT__rst_n));
    bufp->chgBit(oldp+22,(vlSelfRef.tb_sync_fifo__DOT__wr_en));
    bufp->chgBit(oldp+23,(vlSelfRef.tb_sync_fifo__DOT__rd_en));
    bufp->chgCData(oldp+24,(vlSelfRef.tb_sync_fifo__DOT__wdata),8);
    bufp->chgCData(oldp+25,((0x0000001fU & ((IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__wptr) 
                                            - (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__rptr)))),5);
    bufp->chgIData(oldp+26,(vlSelfRef.tb_sync_fifo__DOT__errors),32);
    bufp->chgIData(oldp+27,(vlSelfRef.tb_sync_fifo__DOT__checks),32);
    bufp->chgCData(oldp+28,(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__wptr),5);
    bufp->chgBit(oldp+29,(((~ (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__full)) 
                           & (IData)(vlSelfRef.tb_sync_fifo__DOT__wr_en))));
    bufp->chgBit(oldp+30,(((~ (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__empty)) 
                           & (IData)(vlSelfRef.tb_sync_fifo__DOT__rd_en))));
    bufp->chgCData(oldp+31,(vlSelfRef.tb_sync_fifo__DOT__unnamedblk1__DOT__exp),8);
    bufp->chgBit(oldp+32,(vlSelfRef.tb_sync_fifo__DOT__unnamedblk4__DOT__do_w));
    bufp->chgBit(oldp+33,(vlSelfRef.tb_sync_fifo__DOT__unnamedblk4__DOT__do_r));
}

void Vsync_fifo___024root__trace_chg_dtype____0(Vsync_fifo___024root* vlSelf, VerilatedVcd::Buffer* bufp, uint32_t offset, const VlUnpacked<CData/*7:0*/, 16>& __VdtypeVar) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root__trace_chg_dtype____0\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode +  offset);
    bufp->chgCData(oldp+0,(__VdtypeVar[0]),8);
    bufp->chgCData(oldp+1,(__VdtypeVar[1]),8);
    bufp->chgCData(oldp+2,(__VdtypeVar[2]),8);
    bufp->chgCData(oldp+3,(__VdtypeVar[3]),8);
    bufp->chgCData(oldp+4,(__VdtypeVar[4]),8);
    bufp->chgCData(oldp+5,(__VdtypeVar[5]),8);
    bufp->chgCData(oldp+6,(__VdtypeVar[6]),8);
    bufp->chgCData(oldp+7,(__VdtypeVar[7]),8);
    bufp->chgCData(oldp+8,(__VdtypeVar[8]),8);
    bufp->chgCData(oldp+9,(__VdtypeVar[9]),8);
    bufp->chgCData(oldp+10,(__VdtypeVar[10]),8);
    bufp->chgCData(oldp+11,(__VdtypeVar[11]),8);
    bufp->chgCData(oldp+12,(__VdtypeVar[12]),8);
    bufp->chgCData(oldp+13,(__VdtypeVar[13]),8);
    bufp->chgCData(oldp+14,(__VdtypeVar[14]),8);
    bufp->chgCData(oldp+15,(__VdtypeVar[15]),8);
}

void Vsync_fifo___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root__trace_cleanup\n"); );
    // Body
    Vsync_fifo___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vsync_fifo___024root*>(voidSelf);
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
}
