// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vsync_fifo__Syms.h"


VL_ATTR_COLD void Vsync_fifo___024root__trace_init_dtype____0(Vsync_fifo___024root* vlSelf, VerilatedVcd* tracep, const char* name, uint32_t fidx, uint32_t c, VerilatedTraceSigDirection direction);

VL_ATTR_COLD void Vsync_fifo___024root__trace_init_sub__TOP__0(Vsync_fifo___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root__trace_init_sub__TOP__0\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    VL_TRACE_PUSH_PREFIX(tracep, "tb_sync_fifo", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+34,0,"WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+35,0,"DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+20,0,"clk",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+21,0,"rst_n",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+22,0,"wr_en",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+23,0,"rd_en",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+24,0,"wdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 7,0);
    VL_TRACE_DECL_BUS(tracep,c+0,0,"rdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 7,0);
    VL_TRACE_DECL_BIT(tracep,c+1,0,"full",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+2,0,"empty",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+25,0,"fill_count",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 4,0);
    VL_TRACE_DECL_BUS(tracep,c+26,0,"errors",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+27,0,"checks",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_PUSH_PREFIX(tracep, "dut", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+34,0,"WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+35,0,"DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+20,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+21,0,"rst_n",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+22,0,"wr_en",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+24,0,"wdata",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 7,0);
    VL_TRACE_DECL_BIT(tracep,c+1,0,"full",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+23,0,"rd_en",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+0,0,"rdata",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 7,0);
    VL_TRACE_DECL_BIT(tracep,c+2,0,"empty",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+25,0,"fill_count",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 4,0);
    VL_TRACE_DECL_BUS(tracep,c+36,0,"AW",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);

    Vsync_fifo___024root__trace_init_dtype____0(vlSelf, tracep, "mem", 0, c+3, VerilatedTraceSigDirection::NONE);
    VL_TRACE_DECL_BUS(tracep,c+28,0,"wptr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 4,0);
    VL_TRACE_DECL_BUS(tracep,c+19,0,"rptr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 4,0);
    VL_TRACE_DECL_BIT(tracep,c+29,0,"wr_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+30,0,"rd_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "unnamedblk1", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+31,0,"exp",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 7,0);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "unnamedblk4", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BIT(tracep,c+32,0,"do_w",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::BIT);
    VL_TRACE_DECL_BIT(tracep,c+33,0,"do_r",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::BIT);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_POP_PREFIX(tracep);
}

VL_ATTR_COLD void Vsync_fifo___024root__trace_init_dtype_sub____0(Vsync_fifo___024root* vlSelf, VerilatedVcd* tracep, const char* name, uint32_t fidx, uint32_t c, VerilatedTraceSigDirection direction);

VL_ATTR_COLD void Vsync_fifo___024root__trace_init_dtype____0(Vsync_fifo___024root* vlSelf, VerilatedVcd* tracep, const char* name, uint32_t fidx, uint32_t c, VerilatedTraceSigDirection direction) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root__trace_init_dtype____0\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vsync_fifo___024root__trace_init_dtype_sub____0(vlSelf, tracep, name, fidx, c, direction);
}

VL_ATTR_COLD void Vsync_fifo___024root__trace_init_dtype_sub____0(Vsync_fifo___024root* vlSelf, VerilatedVcd* tracep, const char* name, uint32_t fidx, uint32_t c, VerilatedTraceSigDirection direction) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root__trace_init_dtype_sub____0\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    VL_TRACE_PUSH_PREFIX(tracep, name, VerilatedTracePrefixType::ARRAY_UNPACKED, 0, 15);
    for (int i = 0; i < 16; ++i) {
        VL_TRACE_DECL_BUS_ARRAY(tracep,c+0+i*1,fidx,"",-1, direction, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, (i + 0), 7,0);
    }
    VL_TRACE_POP_PREFIX(tracep);
}

VL_ATTR_COLD void Vsync_fifo___024root__trace_init_top(Vsync_fifo___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root__trace_init_top\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vsync_fifo___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vsync_fifo___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vsync_fifo___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vsync_fifo___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vsync_fifo___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vsync_fifo___024root__trace_register(Vsync_fifo___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root__trace_register\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    tracep->addConstCb(&Vsync_fifo___024root__trace_const_0, 0, vlSelf);
    tracep->addFullCb(&Vsync_fifo___024root__trace_full_0, 0, vlSelf);
    tracep->addChgCb(&Vsync_fifo___024root__trace_chg_0, 0, vlSelf);
    tracep->addCleanupCb(&Vsync_fifo___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vsync_fifo___024root__trace_const_0_sub_0(Vsync_fifo___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vsync_fifo___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root__trace_const_0\n"); );
    // Body
    Vsync_fifo___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vsync_fifo___024root*>(voidSelf);
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Vsync_fifo___024root__trace_const_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vsync_fifo___024root__trace_const_0_sub_0(Vsync_fifo___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root__trace_const_0_sub_0\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullIData(oldp+34,(8U),32);
    bufp->fullIData(oldp+35,(0x00000010U),32);
    bufp->fullIData(oldp+36,(4U),32);
}

VL_ATTR_COLD void Vsync_fifo___024root__trace_full_0_sub_0(Vsync_fifo___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vsync_fifo___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root__trace_full_0\n"); );
    // Body
    Vsync_fifo___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vsync_fifo___024root*>(voidSelf);
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Vsync_fifo___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vsync_fifo___024root__trace_full_dtype____0(Vsync_fifo___024root* vlSelf, VerilatedVcd::Buffer* bufp, uint32_t offset, const VlUnpacked<CData/*7:0*/, 16>& __VdtypeVar);

VL_ATTR_COLD void Vsync_fifo___024root__trace_full_0_sub_0(Vsync_fifo___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root__trace_full_0_sub_0\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullCData(oldp+0,(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__mem
                            [(0x0000000fU & (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__rptr))]),8);
    bufp->fullBit(oldp+1,(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__full));
    bufp->fullBit(oldp+2,(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__empty));
    Vsync_fifo___024root__trace_full_dtype____0(vlSelf, bufp, 3, vlSelfRef.tb_sync_fifo__DOT__dut__DOT__mem);
    bufp->fullCData(oldp+19,(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__rptr),5);
    bufp->fullBit(oldp+20,(vlSelfRef.tb_sync_fifo__DOT__clk));
    bufp->fullBit(oldp+21,(vlSelfRef.tb_sync_fifo__DOT__rst_n));
    bufp->fullBit(oldp+22,(vlSelfRef.tb_sync_fifo__DOT__wr_en));
    bufp->fullBit(oldp+23,(vlSelfRef.tb_sync_fifo__DOT__rd_en));
    bufp->fullCData(oldp+24,(vlSelfRef.tb_sync_fifo__DOT__wdata),8);
    bufp->fullCData(oldp+25,((0x0000001fU & ((IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__wptr) 
                                             - (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__rptr)))),5);
    bufp->fullIData(oldp+26,(vlSelfRef.tb_sync_fifo__DOT__errors),32);
    bufp->fullIData(oldp+27,(vlSelfRef.tb_sync_fifo__DOT__checks),32);
    bufp->fullCData(oldp+28,(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__wptr),5);
    bufp->fullBit(oldp+29,(((~ (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__full)) 
                            & (IData)(vlSelfRef.tb_sync_fifo__DOT__wr_en))));
    bufp->fullBit(oldp+30,(((~ (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__empty)) 
                            & (IData)(vlSelfRef.tb_sync_fifo__DOT__rd_en))));
    bufp->fullCData(oldp+31,(vlSelfRef.tb_sync_fifo__DOT__unnamedblk1__DOT__exp),8);
    bufp->fullBit(oldp+32,(vlSelfRef.tb_sync_fifo__DOT__unnamedblk4__DOT__do_w));
    bufp->fullBit(oldp+33,(vlSelfRef.tb_sync_fifo__DOT__unnamedblk4__DOT__do_r));
}

VL_ATTR_COLD void Vsync_fifo___024root__trace_full_dtype____0(Vsync_fifo___024root* vlSelf, VerilatedVcd::Buffer* bufp, uint32_t offset, const VlUnpacked<CData/*7:0*/, 16>& __VdtypeVar) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root__trace_full_dtype____0\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + offset);
    bufp->fullCData(oldp+0,(__VdtypeVar[0]),8);
    bufp->fullCData(oldp+1,(__VdtypeVar[1]),8);
    bufp->fullCData(oldp+2,(__VdtypeVar[2]),8);
    bufp->fullCData(oldp+3,(__VdtypeVar[3]),8);
    bufp->fullCData(oldp+4,(__VdtypeVar[4]),8);
    bufp->fullCData(oldp+5,(__VdtypeVar[5]),8);
    bufp->fullCData(oldp+6,(__VdtypeVar[6]),8);
    bufp->fullCData(oldp+7,(__VdtypeVar[7]),8);
    bufp->fullCData(oldp+8,(__VdtypeVar[8]),8);
    bufp->fullCData(oldp+9,(__VdtypeVar[9]),8);
    bufp->fullCData(oldp+10,(__VdtypeVar[10]),8);
    bufp->fullCData(oldp+11,(__VdtypeVar[11]),8);
    bufp->fullCData(oldp+12,(__VdtypeVar[12]),8);
    bufp->fullCData(oldp+13,(__VdtypeVar[13]),8);
    bufp->fullCData(oldp+14,(__VdtypeVar[14]),8);
    bufp->fullCData(oldp+15,(__VdtypeVar[15]),8);
}
