// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vsync_fifo.h for the primary calling header

#include "Vsync_fifo__pch.h"

void Vsync_fifo___024root___timing_ready(Vsync_fifo___024root* vlSelf);

VL_ATTR_COLD void Vsync_fifo___024root___eval_static(Vsync_fifo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___eval_static\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    {
        // Inlined CFunc: _eval_static__TOP
        vlSelfRef.tb_sync_fifo__DOT__clk = 0U;
        vlSelfRef.tb_sync_fifo__DOT__errors = 0U;
        vlSelfRef.tb_sync_fifo__DOT__checks = 0U;
        const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
        vlSelfRef.tb_sync_fifo__DOT__unnamedblk1__DOT__exp = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 3227650185023008603ull);
        vlSelfRef.tb_sync_fifo__DOT__unnamedblk4__DOT__do_w = 0U;
        vlSelfRef.tb_sync_fifo__DOT__unnamedblk4__DOT__do_r = 0U;
    }
    vlSelfRef.__Vtrigprevexpr___TOP__tb_sync_fifo__DOT__clk__0 = 0U;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_sync_fifo__DOT__rst_n__0 
        = vlSelfRef.tb_sync_fifo__DOT__rst_n;
    Vsync_fifo___024root___timing_ready(vlSelf);
    do {
        vlSelfRef.__VactTriggeredAcc[vlSelfRef.__Vi] 
            = vlSelfRef.__VactTriggered[vlSelfRef.__Vi];
        vlSelfRef.__Vi = ((IData)(1U) + vlSelfRef.__Vi);
    } while ((0U >= vlSelfRef.__Vi));
}

VL_ATTR_COLD void Vsync_fifo___024root___eval_final(Vsync_fifo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___eval_final\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vsync_fifo___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vsync_fifo___024root___eval_phase__stl(Vsync_fifo___024root* vlSelf);

VL_ATTR_COLD void Vsync_fifo___024root___eval_settle(Vsync_fifo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___eval_settle\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VstlIterCount;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vsync_fifo___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
#endif
            VL_FATAL_MT("tb_sync_fifo.sv", 6, "", "DIDNOTCONVERGE: Settle region did not converge after '--converge-limit' of 10000 tries");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        vlSelfRef.__VstlPhaseResult = Vsync_fifo___024root___eval_phase__stl(vlSelf);
        vlSelfRef.__VstlFirstIteration = 0U;
    } while (vlSelfRef.__VstlPhaseResult);
}

VL_ATTR_COLD bool Vsync_fifo___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vsync_fifo___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(Vsync_fifo___024root___trigger_anySet__stl(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD bool Vsync_fifo___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___trigger_anySet__stl\n"); );
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

VL_ATTR_COLD bool Vsync_fifo___024root___eval_phase__stl(Vsync_fifo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___eval_phase__stl\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VstlExecute;
    // Body
    {
        // Inlined CFunc: _eval_triggers_vec__stl
        vlSelfRef.__VstlTriggered[0U] = ((0xfffffffffffffffeULL 
                                          & vlSelfRef.__VstlTriggered[0U]) 
                                         | (IData)((IData)(vlSelfRef.__VstlFirstIteration)));
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vsync_fifo___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
    }
#endif
    __VstlExecute = Vsync_fifo___024root___trigger_anySet__stl(vlSelfRef.__VstlTriggered);
    if (__VstlExecute) {
        {
            // Inlined CFunc: _eval_stl
            if ((1ULL & vlSelfRef.__VstlTriggered[0U])) {
                {
                    // Inlined CFunc: _stl_sequent__TOP__0
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
                {
                    // Inlined CFunc: __Vm_traceActivitySetAll
                    vlSelfRef.__Vm_traceActivity[0U] = 1U;
                    vlSelfRef.__Vm_traceActivity[1U] = 1U;
                }
            }
        }
    }
    return (__VstlExecute);
}

bool Vsync_fifo___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vsync_fifo___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(Vsync_fifo___024root___trigger_anySet__act(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @(posedge tb_sync_fifo.clk)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 1U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 1 is active: @(negedge tb_sync_fifo.rst_n)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 2U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 2 is active: @(negedge tb_sync_fifo.clk)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 3U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 3 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vsync_fifo___024root___ctor_var_reset(Vsync_fifo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsync_fifo___024root___ctor_var_reset\n"); );
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->tb_sync_fifo__DOT__rst_n = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12303410053635814759ull);
    vlSelf->tb_sync_fifo__DOT__wr_en = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 18208166083735679274ull);
    vlSelf->tb_sync_fifo__DOT__rd_en = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 7548510650479290529ull);
    vlSelf->tb_sync_fifo__DOT__wdata = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 5908684279112949945ull);
    vlSelf->tb_sync_fifo__DOT__ref_model.atDefault() = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 3990746282569124196ull);
    vlSelf->tb_sync_fifo__DOT__dut__DOT__full = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16765538064890803701ull);
    vlSelf->tb_sync_fifo__DOT__dut__DOT__empty = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 6802542889208774372ull);
    for (int __Vi0 = 0; __Vi0 < 16; ++__Vi0) {
        vlSelf->tb_sync_fifo__DOT__dut__DOT__mem[__Vi0] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 5423066854902772731ull);
    }
    vlSelf->tb_sync_fifo__DOT__dut__DOT__wptr = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 5849201735065465203ull);
    vlSelf->tb_sync_fifo__DOT__dut__DOT__rptr = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 2275211615457710230ull);
    vlSelf->__Vdly__tb_sync_fifo__DOT__dut__DOT__rptr = 0;
    vlSelf->__VdlyVal__tb_sync_fifo__DOT__dut__DOT__mem__v0 = 0;
    vlSelf->__VdlyDim0__tb_sync_fifo__DOT__dut__DOT__mem__v0 = 0;
    vlSelf->__VdlySet__tb_sync_fifo__DOT__dut__DOT__mem__v0 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VstlTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggeredAcc[__Vi0] = 0;
    }
    vlSelf->__Vtrigprevexpr___TOP__tb_sync_fifo__DOT__clk__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__tb_sync_fifo__DOT__rst_n__0 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VnbaTriggered[__Vi0] = 0;
    }
    vlSelf->__Vi = 0;
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
