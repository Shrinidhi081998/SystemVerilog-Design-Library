// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vsync_fifo.h for the primary calling header

#include "Vsync_fifo__pch.h"

void Vsync_fifo___024root___ctor_var_reset(Vsync_fifo___024root* vlSelf);

Vsync_fifo___024root::Vsync_fifo___024root(Vsync_fifo__Syms* symsp, const char* namep)
    : __VdlySched{*symsp->_vm_contextp__}
 {
    vlSymsp = symsp;
    vlNamep = strdup(namep);
    // Reset structure values
    Vsync_fifo___024root___ctor_var_reset(this);
}

void Vsync_fifo___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vsync_fifo___024root::~Vsync_fifo___024root() {
    VL_DO_DANGLING(std::free(const_cast<char*>(vlNamep)), vlNamep);
}
