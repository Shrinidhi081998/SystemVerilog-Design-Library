// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vsync_fifo__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vsync_fifo::Vsync_fifo(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vsync_fifo__Syms(contextp(), _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
    contextp()->traceBaseModelCbAdd(
        [this](VerilatedTraceBaseC* tfp, int levels, int options) { traceBaseModel(tfp, levels, options); });
}

Vsync_fifo::Vsync_fifo(const char* _vcname__)
    : Vsync_fifo(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vsync_fifo::~Vsync_fifo() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vsync_fifo___024root___eval_debug_assertions(Vsync_fifo___024root* vlSelf);
#endif  // VL_DEBUG
void Vsync_fifo___024root___eval_static(Vsync_fifo___024root* vlSelf);
void Vsync_fifo___024root___eval_initial(Vsync_fifo___024root* vlSelf);
void Vsync_fifo___024root___eval_settle(Vsync_fifo___024root* vlSelf);
void Vsync_fifo___024root___eval(Vsync_fifo___024root* vlSelf);

void Vsync_fifo::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vsync_fifo::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vsync_fifo___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vsync_fifo___024root___eval_static(&(vlSymsp->TOP));
        Vsync_fifo___024root___eval_initial(&(vlSymsp->TOP));
        Vsync_fifo___024root___eval_settle(&(vlSymsp->TOP));
        vlSymsp->__Vm_didInit = true;
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vsync_fifo___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

void Vsync_fifo::eval_end_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+eval_end_step Vsync_fifo::eval_end_step\n"); );
#ifdef VM_TRACE
    // Tracing
    if (VL_UNLIKELY(vlSymsp->__Vm_dumping)) vlSymsp->_traceDump();
#endif  // VM_TRACE
}

//============================================================
// Events and timing
bool Vsync_fifo::eventsPending() { return !vlSymsp->TOP.__VdlySched.empty() && !contextp()->gotFinish(); }

uint64_t Vsync_fifo::nextTimeSlot() { return vlSymsp->TOP.__VdlySched.nextTimeSlot(); }

//============================================================
// Utilities

const char* Vsync_fifo::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vsync_fifo___024root___eval_final(Vsync_fifo___024root* vlSelf);

VL_ATTR_COLD void Vsync_fifo::final() {
    contextp()->executingFinal(true);
    Vsync_fifo___024root___eval_final(&(vlSymsp->TOP));
    contextp()->executingFinal(false);
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vsync_fifo::hierName() const { return vlSymsp->name(); }
const char* Vsync_fifo::modelName() const { return "Vsync_fifo"; }
unsigned Vsync_fifo::threads() const { return 1; }
void Vsync_fifo::prepareClone() const { contextp()->prepareClone(); }
void Vsync_fifo::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vsync_fifo::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false}};
};

//============================================================
// Trace configuration

void Vsync_fifo___024root__trace_decl_types(VerilatedVcd* tracep);

void Vsync_fifo___024root__trace_init_top(Vsync_fifo___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vsync_fifo___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vsync_fifo___024root*>(voidSelf);
    Vsync_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(vlSymsp->name(), VerilatedTracePrefixType::SCOPE_MODULE);
    Vsync_fifo___024root__trace_decl_types(tracep);
    Vsync_fifo___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vsync_fifo___024root__trace_register(Vsync_fifo___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vsync_fifo::traceBaseModel(VerilatedTraceBaseC* tfp, int levels, int options) {
    (void)levels; (void)options;
    VerilatedVcdC* const stfp = dynamic_cast<VerilatedVcdC*>(tfp);
    if (VL_UNLIKELY(!stfp)) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vsync_fifo::trace()' called on non-VerilatedVcdC object;"
            " use --trace-fst with VerilatedFst object, and --trace-vcd with VerilatedVcd object");
    }
    stfp->spTrace()->addModel(this);
    stfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP), name(), false, 37);
    Vsync_fifo___024root__trace_register(&(vlSymsp->TOP), stfp->spTrace());
}
