// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_sync_fifo.h for the primary calling header

#ifndef VERILATED_VTB_SYNC_FIFO___024ROOT_H_
#define VERILATED_VTB_SYNC_FIFO___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vtb_sync_fifo__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_sync_fifo___024root final {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ tb_sync_fifo__DOT__clk;
    CData/*0:0*/ tb_sync_fifo__DOT__rst_n;
    CData/*0:0*/ tb_sync_fifo__DOT__wr_en;
    CData/*0:0*/ tb_sync_fifo__DOT__rd_en;
    CData/*7:0*/ tb_sync_fifo__DOT__wdata;
    CData/*0:0*/ tb_sync_fifo__DOT__full;
    CData/*0:0*/ tb_sync_fifo__DOT__empty;
    CData/*7:0*/ tb_sync_fifo__DOT__unnamedblk1__DOT__exp;
    CData/*0:0*/ tb_sync_fifo__DOT__unnamedblk4__DOT__do_w;
    CData/*0:0*/ tb_sync_fifo__DOT__unnamedblk4__DOT__do_r;
    CData/*4:0*/ tb_sync_fifo__DOT__dut__DOT__wptr;
    CData/*4:0*/ tb_sync_fifo__DOT__dut__DOT__rptr;
    CData/*4:0*/ __Vdly__tb_sync_fifo__DOT__dut__DOT__rptr;
    CData/*7:0*/ __VdlyVal__tb_sync_fifo__DOT__dut__DOT__mem__v0;
    CData/*3:0*/ __VdlyDim0__tb_sync_fifo__DOT__dut__DOT__mem__v0;
    CData/*0:0*/ __VdlySet__tb_sync_fifo__DOT__dut__DOT__mem__v0;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __VstlPhaseResult;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb_sync_fifo__DOT__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb_sync_fifo__DOT__rst_n__0;
    CData/*0:0*/ __VactPhaseResult;
    CData/*0:0*/ __VinactPhaseResult;
    CData/*0:0*/ __VnbaPhaseResult;
    IData/*31:0*/ tb_sync_fifo__DOT____VlemExpr_1;
    IData/*31:0*/ tb_sync_fifo__DOT____VlemExpr_0;
    IData/*31:0*/ tb_sync_fifo__DOT__errors;
    IData/*31:0*/ tb_sync_fifo__DOT__checks;
    IData/*31:0*/ __VactIterCount;
    IData/*31:0*/ __VinactIterCount;
    IData/*31:0*/ __Vi;
    VlUnpacked<CData/*7:0*/, 16> tb_sync_fifo__DOT__dut__DOT__mem;
    VlUnpacked<QData/*63:0*/, 1> __VstlTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VactTriggeredAcc;
    VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;
    VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;
    VlQueue<CData/*7:0*/> tb_sync_fifo__DOT__ref_model;
    VlDelayScheduler __VdlySched;
    VlTriggerScheduler __VtrigSched_h74ae5157__0;
    VlTriggerScheduler __VtrigSched_h74ae5116__0;

    // INTERNAL VARIABLES
    Vtb_sync_fifo__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vtb_sync_fifo___024root(Vtb_sync_fifo__Syms* symsp, const char* namep);
    ~Vtb_sync_fifo___024root();
    VL_UNCOPYABLE(Vtb_sync_fifo___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
