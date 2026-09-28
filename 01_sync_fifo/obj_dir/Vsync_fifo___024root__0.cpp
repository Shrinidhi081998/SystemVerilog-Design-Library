// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vsync_fifo.h for the primary calling header

#include "Vsync_fifo__pch.h"

VlCoroutine Vsync_fifo___024root___eval_initial__TOP__Vtiming__0(Vsync_fifo___024root* vlSelf);
VlCoroutine Vsync_fifo___024root___eval_initial__TOP__Vtiming__1(Vsync_fifo___024root* vlSelf);

void Vsync_fifo___024root___eval_initial(Vsync_fifo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___eval_initial\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    {
        // Inlined CFunc: _eval_initial__TOP
        vlSymsp->_vm_contextp__->dumpfile("sync_fifo.vcd"s);
        vlSymsp->_traceDumpOpen();
    }
    Vsync_fifo___024root___eval_initial__TOP__Vtiming__0(vlSelf);
    Vsync_fifo___024root___eval_initial__TOP__Vtiming__1(vlSelf);
}

void Vsync_fifo___024root____VbeforeTrig_h74ae5157__0(Vsync_fifo___024root* vlSelf, const char* __VeventDescription);
void Vsync_fifo___024root____VbeforeTrig_h74ae5116__0(Vsync_fifo___024root* vlSelf, const char* __VeventDescription);

VlCoroutine Vsync_fifo___024root___eval_initial__TOP__Vtiming__0(Vsync_fifo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___eval_initial__TOP__Vtiming__0\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ tb_sync_fifo__DOT__unnamedblk1_1__DOT____Vrepeat0;
    tb_sync_fifo__DOT__unnamedblk1_1__DOT____Vrepeat0 = 0;
    IData/*31:0*/ tb_sync_fifo__DOT__unnamedblk2__DOT__i;
    tb_sync_fifo__DOT__unnamedblk2__DOT__i = 0;
    IData/*31:0*/ tb_sync_fifo__DOT__unnamedblk3__DOT__i;
    tb_sync_fifo__DOT__unnamedblk3__DOT__i = 0;
    IData/*31:0*/ tb_sync_fifo__DOT__unnamedblk4__DOT__unnamedblk5__DOT__i;
    tb_sync_fifo__DOT__unnamedblk4__DOT__unnamedblk5__DOT__i = 0;
    CData/*7:0*/ __Vtask_tb_sync_fifo__DOT__do_write__0__d;
    __Vtask_tb_sync_fifo__DOT__do_write__0__d = 0;
    CData/*7:0*/ __Vtask_tb_sync_fifo__DOT__do_write__1__d;
    __Vtask_tb_sync_fifo__DOT__do_write__1__d = 0;
    // Body
    vlSelfRef.tb_sync_fifo__DOT__wr_en = 0U;
    vlSelfRef.tb_sync_fifo__DOT__rd_en = 0U;
    vlSelfRef.tb_sync_fifo__DOT__wdata = 0U;
    vlSelfRef.tb_sync_fifo__DOT__rst_n = 0U;
    tb_sync_fifo__DOT__unnamedblk1_1__DOT____Vrepeat0 = 3U;
    while (VL_LTS_III(32, 0U, tb_sync_fifo__DOT__unnamedblk1_1__DOT____Vrepeat0)) {
        Vsync_fifo___024root____VbeforeTrig_h74ae5157__0(vlSelf, 
                                                         "@(posedge tb_sync_fifo.clk)");
        co_await vlSelfRef.__VtrigSched_h74ae5157__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_sync_fifo.clk)", 
                                                             "tb_sync_fifo.sv", 
                                                             80);
        tb_sync_fifo__DOT__unnamedblk1_1__DOT____Vrepeat0 
            = (tb_sync_fifo__DOT__unnamedblk1_1__DOT____Vrepeat0 
               - (IData)(1U));
    }
    vlSelfRef.tb_sync_fifo__DOT__rst_n = 1U;
    Vsync_fifo___024root____VbeforeTrig_h74ae5157__0(vlSelf, 
                                                     "@(posedge tb_sync_fifo.clk)");
    co_await vlSelfRef.__VtrigSched_h74ae5157__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_sync_fifo.clk)", 
                                                         "tb_sync_fifo.sv", 
                                                         82);
    tb_sync_fifo__DOT__unnamedblk2__DOT__i = 0U;
    while (VL_GTS_III(32, 0x00000010U, tb_sync_fifo__DOT__unnamedblk2__DOT__i)) {
        __Vtask_tb_sync_fifo__DOT__do_write__0__d = 
            (0x000000ffU & tb_sync_fifo__DOT__unnamedblk2__DOT__i);
        Vsync_fifo___024root____VbeforeTrig_h74ae5116__0(vlSelf, 
                                                         "@(negedge tb_sync_fifo.clk)");
        co_await vlSelfRef.__VtrigSched_h74ae5116__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(negedge tb_sync_fifo.clk)", 
                                                             "tb_sync_fifo.sv", 
                                                             64);
        vlSelfRef.tb_sync_fifo__DOT__wr_en = 1U;
        vlSelfRef.tb_sync_fifo__DOT__wdata = __Vtask_tb_sync_fifo__DOT__do_write__0__d;
        vlSelfRef.tb_sync_fifo__DOT__rd_en = 0U;
        Vsync_fifo___024root____VbeforeTrig_h74ae5157__0(vlSelf, 
                                                         "@(posedge tb_sync_fifo.clk)");
        co_await vlSelfRef.__VtrigSched_h74ae5157__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_sync_fifo.clk)", 
                                                             "tb_sync_fifo.sv", 
                                                             66);
        co_await vlSelfRef.__VdlySched.delay(0x00000000000003e8ULL, 
                                             nullptr, 
                                             "tb_sync_fifo.sv", 
                                             67);
        vlSelfRef.tb_sync_fifo__DOT__wr_en = 0U;
        tb_sync_fifo__DOT__unnamedblk2__DOT__i = ((IData)(1U) 
                                                  + tb_sync_fifo__DOT__unnamedblk2__DOT__i);
    }
    if (VL_UNLIKELY(((1U & (~ (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__full)))))) {
        VL_WRITEF_NX("ERROR: expected FULL after 16 writes\n",0);
        vlSelfRef.tb_sync_fifo__DOT__errors = ((IData)(1U) 
                                               + vlSelfRef.tb_sync_fifo__DOT__errors);
    }
    vlSelfRef.tb_sync_fifo__DOT__checks = ((IData)(1U) 
                                           + vlSelfRef.tb_sync_fifo__DOT__checks);
    __Vtask_tb_sync_fifo__DOT__do_write__1__d = 0xffU;
    Vsync_fifo___024root____VbeforeTrig_h74ae5116__0(vlSelf, 
                                                     "@(negedge tb_sync_fifo.clk)");
    co_await vlSelfRef.__VtrigSched_h74ae5116__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_sync_fifo.clk)", 
                                                         "tb_sync_fifo.sv", 
                                                         64);
    vlSelfRef.tb_sync_fifo__DOT__wr_en = 1U;
    vlSelfRef.tb_sync_fifo__DOT__wdata = __Vtask_tb_sync_fifo__DOT__do_write__1__d;
    vlSelfRef.tb_sync_fifo__DOT__rd_en = 0U;
    Vsync_fifo___024root____VbeforeTrig_h74ae5157__0(vlSelf, 
                                                     "@(posedge tb_sync_fifo.clk)");
    co_await vlSelfRef.__VtrigSched_h74ae5157__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_sync_fifo.clk)", 
                                                         "tb_sync_fifo.sv", 
                                                         66);
    co_await vlSelfRef.__VdlySched.delay(0x00000000000003e8ULL, 
                                         nullptr, "tb_sync_fifo.sv", 
                                         67);
    vlSelfRef.tb_sync_fifo__DOT__wr_en = 0U;
    if (VL_UNLIKELY(((0x00000010U != vlSelfRef.tb_sync_fifo__DOT__ref_model.size())))) {
        VL_WRITEF_NX("ERROR: write-while-full corrupted FIFO, size=%0d\n",1
                     , '~',32,vlSelfRef.tb_sync_fifo__DOT__ref_model.size());
        vlSelfRef.tb_sync_fifo__DOT__errors = ((IData)(1U) 
                                               + vlSelfRef.tb_sync_fifo__DOT__errors);
    }
    vlSelfRef.tb_sync_fifo__DOT__checks = ((IData)(1U) 
                                           + vlSelfRef.tb_sync_fifo__DOT__checks);
    tb_sync_fifo__DOT__unnamedblk3__DOT__i = 0U;
    while (VL_GTS_III(32, 0x00000010U, tb_sync_fifo__DOT__unnamedblk3__DOT__i)) {
        Vsync_fifo___024root____VbeforeTrig_h74ae5116__0(vlSelf, 
                                                         "@(negedge tb_sync_fifo.clk)");
        co_await vlSelfRef.__VtrigSched_h74ae5116__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(negedge tb_sync_fifo.clk)", 
                                                             "tb_sync_fifo.sv", 
                                                             71);
        vlSelfRef.tb_sync_fifo__DOT__rd_en = 1U;
        vlSelfRef.tb_sync_fifo__DOT__wr_en = 0U;
        Vsync_fifo___024root____VbeforeTrig_h74ae5157__0(vlSelf, 
                                                         "@(posedge tb_sync_fifo.clk)");
        co_await vlSelfRef.__VtrigSched_h74ae5157__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_sync_fifo.clk)", 
                                                             "tb_sync_fifo.sv", 
                                                             73);
        co_await vlSelfRef.__VdlySched.delay(0x00000000000003e8ULL, 
                                             nullptr, 
                                             "tb_sync_fifo.sv", 
                                             74);
        vlSelfRef.tb_sync_fifo__DOT__rd_en = 0U;
        tb_sync_fifo__DOT__unnamedblk3__DOT__i = ((IData)(1U) 
                                                  + tb_sync_fifo__DOT__unnamedblk3__DOT__i);
    }
    if (VL_UNLIKELY(((1U & (~ (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__empty)))))) {
        VL_WRITEF_NX("ERROR: expected EMPTY after draining\n",0);
        vlSelfRef.tb_sync_fifo__DOT__errors = ((IData)(1U) 
                                               + vlSelfRef.tb_sync_fifo__DOT__errors);
    }
    vlSelfRef.tb_sync_fifo__DOT__checks = ((IData)(1U) 
                                           + vlSelfRef.tb_sync_fifo__DOT__checks);
    Vsync_fifo___024root____VbeforeTrig_h74ae5116__0(vlSelf, 
                                                     "@(negedge tb_sync_fifo.clk)");
    co_await vlSelfRef.__VtrigSched_h74ae5116__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_sync_fifo.clk)", 
                                                         "tb_sync_fifo.sv", 
                                                         71);
    vlSelfRef.tb_sync_fifo__DOT__rd_en = 1U;
    vlSelfRef.tb_sync_fifo__DOT__wr_en = 0U;
    Vsync_fifo___024root____VbeforeTrig_h74ae5157__0(vlSelf, 
                                                     "@(posedge tb_sync_fifo.clk)");
    co_await vlSelfRef.__VtrigSched_h74ae5157__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_sync_fifo.clk)", 
                                                         "tb_sync_fifo.sv", 
                                                         73);
    co_await vlSelfRef.__VdlySched.delay(0x00000000000003e8ULL, 
                                         nullptr, "tb_sync_fifo.sv", 
                                         74);
    vlSelfRef.tb_sync_fifo__DOT__rd_en = 0U;
    tb_sync_fifo__DOT__unnamedblk4__DOT__unnamedblk5__DOT__i = 0U;
    while (VL_GTS_III(32, 0x000001f4U, tb_sync_fifo__DOT__unnamedblk4__DOT__unnamedblk5__DOT__i)) {
        vlSelfRef.tb_sync_fifo__DOT____VlemExpr_0 = 
            VL_URANDOM_RANGE_I(0U, 1U);
        vlSelfRef.tb_sync_fifo__DOT__unnamedblk4__DOT__do_w 
            = (1U & vlSelfRef.tb_sync_fifo__DOT____VlemExpr_0);
        vlSelfRef.tb_sync_fifo__DOT____VlemExpr_1 = 
            VL_URANDOM_RANGE_I(0U, 1U);
        vlSelfRef.tb_sync_fifo__DOT__unnamedblk4__DOT__do_r 
            = (1U & vlSelfRef.tb_sync_fifo__DOT____VlemExpr_1);
        Vsync_fifo___024root____VbeforeTrig_h74ae5116__0(vlSelf, 
                                                         "@(negedge tb_sync_fifo.clk)");
        co_await vlSelfRef.__VtrigSched_h74ae5116__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(negedge tb_sync_fifo.clk)", 
                                                             "tb_sync_fifo.sv", 
                                                             111);
        vlSelfRef.tb_sync_fifo__DOT__wr_en = vlSelfRef.tb_sync_fifo__DOT__unnamedblk4__DOT__do_w;
        vlSelfRef.tb_sync_fifo__DOT__wdata = (0x000000ffU 
                                              & VL_RANDOM_I());
        vlSelfRef.tb_sync_fifo__DOT__rd_en = vlSelfRef.tb_sync_fifo__DOT__unnamedblk4__DOT__do_r;
        Vsync_fifo___024root____VbeforeTrig_h74ae5157__0(vlSelf, 
                                                         "@(posedge tb_sync_fifo.clk)");
        co_await vlSelfRef.__VtrigSched_h74ae5157__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_sync_fifo.clk)", 
                                                             "tb_sync_fifo.sv", 
                                                             114);
        co_await vlSelfRef.__VdlySched.delay(0x00000000000003e8ULL, 
                                             nullptr, 
                                             "tb_sync_fifo.sv", 
                                             115);
        tb_sync_fifo__DOT__unnamedblk4__DOT__unnamedblk5__DOT__i 
            = ((IData)(1U) + tb_sync_fifo__DOT__unnamedblk4__DOT__unnamedblk5__DOT__i);
    }
    vlSelfRef.tb_sync_fifo__DOT__wr_en = 0U;
    vlSelfRef.tb_sync_fifo__DOT__rd_en = 0U;
    while (VL_LTS_III(32, 0U, vlSelfRef.tb_sync_fifo__DOT__ref_model.size())) {
        Vsync_fifo___024root____VbeforeTrig_h74ae5116__0(vlSelf, 
                                                         "@(negedge tb_sync_fifo.clk)");
        co_await vlSelfRef.__VtrigSched_h74ae5116__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(negedge tb_sync_fifo.clk)", 
                                                             "tb_sync_fifo.sv", 
                                                             71);
        vlSelfRef.tb_sync_fifo__DOT__rd_en = 1U;
        vlSelfRef.tb_sync_fifo__DOT__wr_en = 0U;
        Vsync_fifo___024root____VbeforeTrig_h74ae5157__0(vlSelf, 
                                                         "@(posedge tb_sync_fifo.clk)");
        co_await vlSelfRef.__VtrigSched_h74ae5157__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_sync_fifo.clk)", 
                                                             "tb_sync_fifo.sv", 
                                                             73);
        co_await vlSelfRef.__VdlySched.delay(0x00000000000003e8ULL, 
                                             nullptr, 
                                             "tb_sync_fifo.sv", 
                                             74);
        vlSelfRef.tb_sync_fifo__DOT__rd_en = 0U;
    }
    Vsync_fifo___024root____VbeforeTrig_h74ae5157__0(vlSelf, 
                                                     "@(posedge tb_sync_fifo.clk)");
    co_await vlSelfRef.__VtrigSched_h74ae5157__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_sync_fifo.clk)", 
                                                         "tb_sync_fifo.sv", 
                                                         123);
    VL_WRITEF_NX("--------------------------------------------------\n",0);
    if ((0U == vlSelfRef.tb_sync_fifo__DOT__errors)) {
        VL_WRITEF_NX("SYNC FIFO: ALL %0d CHECKS PASSED\n",1
                     , '~',32,vlSelfRef.tb_sync_fifo__DOT__checks);
    } else {
        VL_WRITEF_NX("SYNC FIFO: %0d ERRORS out of %0d checks\n",2
                     , '~',32,vlSelfRef.tb_sync_fifo__DOT__errors
                     , '~',32,vlSelfRef.tb_sync_fifo__DOT__checks);
    }
    VL_WRITEF_NX("--------------------------------------------------\n",0);
    co_await vlSelfRef.__VdlySched.delay(0x0000000000004e20ULL, 
                                         nullptr, "tb_sync_fifo.sv", 
                                         130);
    VL_FINISH_MT("tb_sync_fifo.sv", 130, "");
    co_return;
}

VlCoroutine Vsync_fifo___024root___eval_initial__TOP__Vtiming__1(Vsync_fifo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___eval_initial__TOP__Vtiming__1\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    while (VL_LIKELY(!vlSymsp->_vm_contextp__->gotFinish())) {
        co_await vlSelfRef.__VdlySched.delay(0x0000000000001388ULL, 
                                             nullptr, 
                                             "tb_sync_fifo.sv", 
                                             29);
        vlSelfRef.tb_sync_fifo__DOT__clk = (1U & (~ (IData)(vlSelfRef.tb_sync_fifo__DOT__clk)));
    }
    co_return;
}

bool Vsync_fifo___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___trigger_anySet__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

void Vsync_fifo___024root___timing_ready(Vsync_fifo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___timing_ready\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VactTriggered[0U])) {
        vlSelfRef.__VtrigSched_h74ae5157__0.ready("@(posedge tb_sync_fifo.clk)");
    }
    if ((4ULL & vlSelfRef.__VactTriggered[0U])) {
        vlSelfRef.__VtrigSched_h74ae5116__0.ready("@(negedge tb_sync_fifo.clk)");
    }
}

void Vsync_fifo___024root___timing_resume(Vsync_fifo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___timing_resume\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VtrigSched_h74ae5157__0.moveToResumeQueue(
                                                          "@(posedge tb_sync_fifo.clk)");
    vlSelfRef.__VtrigSched_h74ae5116__0.moveToResumeQueue(
                                                          "@(negedge tb_sync_fifo.clk)");
    vlSelfRef.__VtrigSched_h74ae5157__0.resume("@(posedge tb_sync_fifo.clk)");
    vlSelfRef.__VtrigSched_h74ae5116__0.resume("@(negedge tb_sync_fifo.clk)");
    if ((8ULL & vlSelfRef.__VactTriggered[0U])) {
        vlSelfRef.__VdlySched.resume();
    }
}

void Vsync_fifo___024root___trigger_orInto__act_vec_vec(VlUnpacked<QData/*63:0*/, 1> &out, const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___trigger_orInto__act_vec_vec\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = (out[n] | in[n]);
        n = ((IData)(1U) + n);
    } while ((0U >= n));
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vsync_fifo___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vsync_fifo___024root___eval_phase__act(Vsync_fifo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___eval_phase__act\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VactExecute;
    // Body
    {
        // Inlined CFunc: _eval_triggers_vec__act
        vlSelfRef.__VactTriggered[0U] = (QData)((IData)(
                                                        (((vlSelfRef.__VdlySched.awaitingCurrentTime() 
                                                           << 3U) 
                                                          | (((~ (IData)(vlSelfRef.tb_sync_fifo__DOT__clk)) 
                                                              & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_sync_fifo__DOT__clk__0)) 
                                                             << 2U)) 
                                                         | ((((~ (IData)(vlSelfRef.tb_sync_fifo__DOT__rst_n)) 
                                                              & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_sync_fifo__DOT__rst_n__0)) 
                                                             << 1U) 
                                                            | ((IData)(vlSelfRef.tb_sync_fifo__DOT__clk) 
                                                               & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_sync_fifo__DOT__clk__0)))))));
        vlSelfRef.__Vtrigprevexpr___TOP__tb_sync_fifo__DOT__clk__0 
            = vlSelfRef.tb_sync_fifo__DOT__clk;
        vlSelfRef.__Vtrigprevexpr___TOP__tb_sync_fifo__DOT__rst_n__0 
            = vlSelfRef.tb_sync_fifo__DOT__rst_n;
    }
    Vsync_fifo___024root___timing_ready(vlSelf);
    Vsync_fifo___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VactTriggered, vlSelfRef.__VactTriggeredAcc);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vsync_fifo___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
    }
#endif
    Vsync_fifo___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VnbaTriggered, vlSelfRef.__VactTriggered);
    __VactExecute = Vsync_fifo___024root___trigger_anySet__act(vlSelfRef.__VactTriggered);
    if (__VactExecute) {
        vlSelfRef.__VactTriggeredAcc.fill(0ULL);
        Vsync_fifo___024root___timing_resume(vlSelf);
    }
    return (__VactExecute);
}

bool Vsync_fifo___024root___eval_phase__inact(Vsync_fifo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___eval_phase__inact\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VinactExecute;
    // Body
    __VinactExecute = vlSelfRef.__VdlySched.awaitingZeroDelay();
    if (__VinactExecute) {
        VL_FATAL_MT("tb_sync_fifo.sv", 6, "", "ZERODLY: Design Verilated with '--no-sched-zero-delay', but #0 delay executed at runtime");
    }
    return (__VinactExecute);
}

void Vsync_fifo___024root___trigger_clear__act(VlUnpacked<QData/*63:0*/, 1> &out) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___trigger_clear__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = 0ULL;
        n = ((IData)(1U) + n);
    } while ((1U > n));
}

bool Vsync_fifo___024root___eval_phase__nba(Vsync_fifo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___eval_phase__nba\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = Vsync_fifo___024root___trigger_anySet__act(vlSelfRef.__VnbaTriggered);
    if (__VnbaExecute) {
        {
            // Inlined CFunc: _eval_nba
            if ((3ULL & vlSelfRef.__VnbaTriggered[0U])) {
                {
                    // Inlined CFunc: _nba_sequent__TOP__0
                    vlSelfRef.__Vdly__tb_sync_fifo__DOT__dut__DOT__rptr 
                        = vlSelfRef.tb_sync_fifo__DOT__dut__DOT__rptr;
                    vlSelfRef.__VdlySet__tb_sync_fifo__DOT__dut__DOT__mem__v0 = 0U;
                    if (vlSelfRef.tb_sync_fifo__DOT__rst_n) {
                        if (((~ (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__empty)) 
                             & (IData)(vlSelfRef.tb_sync_fifo__DOT__rd_en))) {
                            vlSelfRef.__Vdly__tb_sync_fifo__DOT__dut__DOT__rptr 
                                = (0x0000001fU & ((IData)(1U) 
                                                  + (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__rptr)));
                        }
                        if (((~ (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__full)) 
                             & (IData)(vlSelfRef.tb_sync_fifo__DOT__wr_en))) {
                            vlSelfRef.__VdlyVal__tb_sync_fifo__DOT__dut__DOT__mem__v0 
                                = vlSelfRef.tb_sync_fifo__DOT__wdata;
                            vlSelfRef.__VdlyDim0__tb_sync_fifo__DOT__dut__DOT__mem__v0 
                                = (0x0000000fU & (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__wptr));
                            vlSelfRef.__VdlySet__tb_sync_fifo__DOT__dut__DOT__mem__v0 = 1U;
                            vlSelfRef.tb_sync_fifo__DOT__dut__DOT__wptr 
                                = (0x0000001fU & ((IData)(1U) 
                                                  + (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__wptr)));
                        }
                    } else {
                        vlSelfRef.__Vdly__tb_sync_fifo__DOT__dut__DOT__rptr = 0U;
                        vlSelfRef.tb_sync_fifo__DOT__dut__DOT__wptr = 0U;
                    }
                }
            }
            if ((1ULL & vlSelfRef.__VnbaTriggered[0U])) {
                {
                    // Inlined CFunc: _nba_sequent__TOP__1
                    if (vlSelfRef.tb_sync_fifo__DOT__rst_n) {
                        if (VL_UNLIKELY((((IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__empty) 
                                          != (0U == vlSelfRef.tb_sync_fifo__DOT__ref_model.size()))))) {
                            VL_WRITEF_NX("[%0t] ERROR: empty flag mismatch. dut_empty=%0b ref_size=%0d\n",4, 'T',-9
                                         , '#',64,VL_TIME_UNITED_Q(1000)
                                         , '#',1,(IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__empty)
                                         , '~',32,vlSelfRef.tb_sync_fifo__DOT__ref_model.size());
                            vlSelfRef.tb_sync_fifo__DOT__errors 
                                = ((IData)(1U) + vlSelfRef.tb_sync_fifo__DOT__errors);
                        }
                        vlSelfRef.tb_sync_fifo__DOT__checks 
                            = ((IData)(1U) + vlSelfRef.tb_sync_fifo__DOT__checks);
                        if (((IData)(vlSelfRef.tb_sync_fifo__DOT__wr_en) 
                             & (~ (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__full)))) {
                            vlSelfRef.tb_sync_fifo__DOT__ref_model.push_back(vlSelfRef.tb_sync_fifo__DOT__wdata);
                        }
                        if (((IData)(vlSelfRef.tb_sync_fifo__DOT__rd_en) 
                             & (~ (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__empty)))) {
                            vlSelfRef.tb_sync_fifo__DOT__checks 
                                = ((IData)(1U) + vlSelfRef.tb_sync_fifo__DOT__checks);
                            vlSelfRef.tb_sync_fifo__DOT__unnamedblk1__DOT__exp 
                                = vlSelfRef.tb_sync_fifo__DOT__ref_model.pop_front();
                            if (VL_UNLIKELY(((vlSelfRef.tb_sync_fifo__DOT__dut__DOT__mem
                                              [(0x0000000fU 
                                                & (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__rptr))] 
                                              != (IData)(vlSelfRef.tb_sync_fifo__DOT__unnamedblk1__DOT__exp))))) {
                                vlSelfRef.tb_sync_fifo__DOT__errors 
                                    = ((IData)(1U) 
                                       + vlSelfRef.tb_sync_fifo__DOT__errors);
                                VL_WRITEF_NX("[%0t] ERROR: rdata mismatch. dut=%0h exp=%0h\n",4, 'T',-9
                                             , '#',64,VL_TIME_UNITED_Q(1000)
                                             , '#',8,vlSelfRef.tb_sync_fifo__DOT__dut__DOT__mem
                                             [(0x0000000fU 
                                               & (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__rptr))]
                                             , '#',8,vlSelfRef.tb_sync_fifo__DOT__unnamedblk1__DOT__exp);
                            }
                        }
                    }
                }
            }
            if ((3ULL & vlSelfRef.__VnbaTriggered[0U])) {
                {
                    // Inlined CFunc: _nba_sequent__TOP__2
                    if (vlSelfRef.__VdlySet__tb_sync_fifo__DOT__dut__DOT__mem__v0) {
                        vlSelfRef.tb_sync_fifo__DOT__dut__DOT__mem[vlSelfRef.__VdlyDim0__tb_sync_fifo__DOT__dut__DOT__mem__v0] 
                            = vlSelfRef.__VdlyVal__tb_sync_fifo__DOT__dut__DOT__mem__v0;
                    }
                    vlSelfRef.tb_sync_fifo__DOT__dut__DOT__rptr 
                        = vlSelfRef.__Vdly__tb_sync_fifo__DOT__dut__DOT__rptr;
                    vlSelfRef.tb_sync_fifo__DOT__dut__DOT__full 
                        = (((1U & ((IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__wptr) 
                                   >> 4U)) != (1U & 
                                               ((IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__rptr) 
                                                >> 4U))) 
                           & ((0x0000000fU & (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__rptr)) 
                              == (0x0000000fU & (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__wptr))));
                    vlSelfRef.tb_sync_fifo__DOT__dut__DOT__empty 
                        = ((IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__rptr) 
                           == (IData)(vlSelfRef.tb_sync_fifo__DOT__dut__DOT__wptr));
                }
                vlSelfRef.__Vm_traceActivity[1U] = 1U;
            }
        }
        Vsync_fifo___024root___trigger_clear__act(vlSelfRef.__VnbaTriggered);
    }
    return (__VnbaExecute);
}

void Vsync_fifo___024root___eval(Vsync_fifo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___eval\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VnbaIterCount;
    // Body
    __VnbaIterCount = 0U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vsync_fifo___024root___dump_triggers__act(vlSelfRef.__VnbaTriggered, "nba"s);
#endif
            VL_FATAL_MT("tb_sync_fifo.sv", 6, "", "DIDNOTCONVERGE: NBA region did not converge after '--converge-limit' of 10000 tries");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        vlSelfRef.__VinactIterCount = 0U;
        do {
            if (VL_UNLIKELY(((0x00002710U < vlSelfRef.__VinactIterCount)))) {
                VL_FATAL_MT("tb_sync_fifo.sv", 6, "", "DIDNOTCONVERGE: Inactive region did not converge after '--converge-limit' of 10000 tries");
            }
            vlSelfRef.__VinactIterCount = ((IData)(1U) 
                                           + vlSelfRef.__VinactIterCount);
            vlSelfRef.__VactIterCount = 0U;
            do {
                if (VL_UNLIKELY(((0x00002710U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                    Vsync_fifo___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
#endif
                    VL_FATAL_MT("tb_sync_fifo.sv", 6, "", "DIDNOTCONVERGE: Active region did not converge after '--converge-limit' of 10000 tries");
                }
                vlSelfRef.__VactIterCount = ((IData)(1U) 
                                             + vlSelfRef.__VactIterCount);
                vlSelfRef.__VactPhaseResult = Vsync_fifo___024root___eval_phase__act(vlSelf);
            } while (vlSelfRef.__VactPhaseResult);
            vlSelfRef.__VinactPhaseResult = Vsync_fifo___024root___eval_phase__inact(vlSelf);
        } while (vlSelfRef.__VinactPhaseResult);
        vlSelfRef.__VnbaPhaseResult = Vsync_fifo___024root___eval_phase__nba(vlSelf);
    } while (vlSelfRef.__VnbaPhaseResult);
}

void Vsync_fifo___024root____VbeforeTrig_h74ae5157__0(Vsync_fifo___024root* vlSelf, const char* __VeventDescription) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root____VbeforeTrig_h74ae5157__0\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    VlUnpacked<QData/*63:0*/, 1> __VTmp;
    // Body
    __VTmp[0U] = (QData)((IData)(((((~ (IData)(vlSelfRef.tb_sync_fifo__DOT__clk)) 
                                    & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_sync_fifo__DOT__clk__0)) 
                                   << 2U) | ((IData)(vlSelfRef.tb_sync_fifo__DOT__clk) 
                                             & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_sync_fifo__DOT__clk__0))))));
    vlSelfRef.__Vtrigprevexpr___TOP__tb_sync_fifo__DOT__clk__0 
        = vlSelfRef.tb_sync_fifo__DOT__clk;
    if ((1ULL & __VTmp[0U])) {
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
    }
    if ((4ULL & __VTmp[0U])) {
        vlSelfRef.__VtrigSched_h74ae5116__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5116__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5116__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5116__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5116__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5116__0.ready(__VeventDescription);
    }
    vlSelfRef.__VactTriggeredAcc[0U] = (vlSelfRef.__VactTriggeredAcc[0U] 
                                        | __VTmp[0U]);
}

void Vsync_fifo___024root____VbeforeTrig_h74ae5116__0(Vsync_fifo___024root* vlSelf, const char* __VeventDescription) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root____VbeforeTrig_h74ae5116__0\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    VlUnpacked<QData/*63:0*/, 1> __VTmp;
    // Body
    __VTmp[0U] = (QData)((IData)(((((~ (IData)(vlSelfRef.tb_sync_fifo__DOT__clk)) 
                                    & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_sync_fifo__DOT__clk__0)) 
                                   << 2U) | ((IData)(vlSelfRef.tb_sync_fifo__DOT__clk) 
                                             & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_sync_fifo__DOT__clk__0))))));
    vlSelfRef.__Vtrigprevexpr___TOP__tb_sync_fifo__DOT__clk__0 
        = vlSelfRef.tb_sync_fifo__DOT__clk;
    if ((1ULL & __VTmp[0U])) {
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5157__0.ready(__VeventDescription);
    }
    if ((4ULL & __VTmp[0U])) {
        vlSelfRef.__VtrigSched_h74ae5116__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5116__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5116__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5116__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5116__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h74ae5116__0.ready(__VeventDescription);
    }
    vlSelfRef.__VactTriggeredAcc[0U] = (vlSelfRef.__VactTriggeredAcc[0U] 
                                        | __VTmp[0U]);
}

#ifdef VL_DEBUG
void Vsync_fifo___024root___eval_debug_assertions(Vsync_fifo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___eval_debug_assertions\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}
#endif  // VL_DEBUG
