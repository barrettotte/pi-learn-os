        .section .text

        .global vector_table
        .global enable_irq                // void enable_irq()

        .balign 2048
vector_table:                             // ***** interrupt vector table *****
                                          // each vector can hold up to 32 instructions

current_el_sp0_sync:                      // (1) EL1 with EL0 SP - synchronous exceptions
        b unknown_error                   // UNIMPLEMENTED

        .balign 128
current_el_sp0_irq:                       // (2) EL1 with EL0 SP - interrupts
        b unknown_error                   // UNIMPLEMENTED

        .balign 128
current_el_sp0_fiq:                       // (3) EL1 with EL0 SP - fast interrupts (higher priority)
        b unknown_error                   // UNIMPLEMENTED

        .balign 128
current_el_sp0_serror:                    // (4) EL1 with EL0 SP - system error
        b unknown_error                   // UNIMPLEMENTED

        .balign 128
current_el_spn_sync:                      // (5) EL1 with EL1 SP - synchronous exceptions
        b sync_handler                    // handle synchronous exception

        .balign 128
current_el_spn_irq:                       // (6) EL1 with EL1 SP - interrupts
        b irq_handler                     // handle hardware interrupt

        .balign 128
current_el_spn_fiq:                       // (7) EL1 with EL1 SP - fast interrupts (higher priority)
        b unknown_error                   // UNIMPLEMENTED

        .balign 128
current_el_spn_serror:                    // (8) EL1 with EL1 SP - system error
        b unknown_error                   // UNIMPLEMENTED

        .balign 128
lower_el_aarch64_sync:                    // (9) EL0 in 64-bit mode - synchronous exceptions
        b unknown_error                   // UNIMPLEMENTED

        .balign 128
lower_el_aarch64_irq:                     // (10) EL0 in 64-bit mode - interrupts
        b unknown_error                   // UNIMPLEMENTED

        .balign 128
lower_el_aarch64_fiq:                     // (11) EL0 in 64-bit mode - fast interrupts (higher priority)
        b unknown_error                   // UNIMPLEMENTED

        .balign 128
lower_el_aarch64_serror:                  // (12) EL0 in 64-bit mode - system error
        b unknown_error                   // UNIMPLEMENTED

        .balign 128
lower_el_aarch32_sync:                    // (13) EL0 in 32-bit mode - synchronous exceptions
        b unknown_error                   // UNIMPLEMENTED

        .balign 128
lower_el_aarch32_irq:                     // (14) EL0 in 32-bit mode - interrupts
        b unknown_error                   // UNIMPLEMENTED

        .balign 128
lower_el_aarch32_fiq:                     // (15) EL0 in 32-bit mode - fast interrupts (higher priority)
        b unknown_error                   // UNIMPLEMENTED

        .balign 128
lower_el_aarch32_serror:                  // (16) EL0 in 32-bit mode - system error
        b unknown_error                   // UNIMPLEMENTED

sync_handler:                             // ***** handle synchronous exception *****
        sub sp, sp, #(32 * 8)             // allocate storage for registers

        // TODO: refactor to macro
        stp x0, x1, [sp]                  //
        stp x2, x3, [sp, #(16 * 1)]       //
        stp x4, x5, [sp, #(16 * 2)]       //
        stp x6, x7, [sp, #(16 * 3)]       //
        stp x8, x9, [sp, #(16 * 4)]       //
        stp x10, x11, [sp, #(16 * 5)]     //
        stp x12, x13, [sp, #(16 * 6)]     //
        stp x14, x15, [sp, #(16 * 7)]     //
        stp x16, x17, [sp, #(16 * 8)]     //
        stp x18, x19, [sp, #(16 * 9)]     //
        stp x20, x21, [sp, #(16 * 10)]    //
        stp x22, x23, [sp, #(16 * 11)]    //
        stp x24, x25, [sp, #(16 * 12)]    //
        stp x26, x27, [sp, #(16 * 13)]    //
        stp x28, x29, [sp, #(16 * 14)]    //
        str x30, [sp, #(16 * 15)]         //

        mov x0, #1                        // synchronous exception ID
        mrs x1, esr_el1                   // exception syndrome register EL1, get current exception info
        mrs x2, elr_el1                   // exception link register, get return address
        bl exception_handler              // handle exception

        // TODO: refactor to macro
        ldp x0, x1, [sp]                  //
        ldp x2, x3, [sp, #(16 * 1)]       //
        ldp x4, x5, [sp, #(16 * 2)]       //
        ldp x6, x7, [sp, #(16 * 3)]       //
        ldp x8, x9, [sp, #(16 * 4)]       //
        ldp x10, x11, [sp, #(16 * 5)]     //
        ldp x12, x13, [sp, #(16 * 6)]     //
        ldp x14, x15, [sp, #(16 * 7)]     //
        ldp x16, x17, [sp, #(16 * 8)]     //
        ldp x18, x19, [sp, #(16 * 9)]     //
        ldp x20, x21, [sp, #(16 * 10)]    //
        ldp x22, x23, [sp, #(16 * 11)]    //
        ldp x24, x25, [sp, #(16 * 12)]    //
        ldp x26, x27, [sp, #(16 * 13)]    //
        ldp x28, x29, [sp, #(16 * 14)]    //
        ldr x30, [sp, #(16 * 15)]         //

        add sp, sp, #(32 * 8)             // deallocate stack storage

        eret                              // return to previous execution

unknown_error:                           // ***** handle unknown error *****
        sub sp, sp, #(32 * 8)             // allocate storage for registers

        // TODO: refactor to macro
        stp x0, x1, [sp]                  //
        stp x2, x3, [sp, #(16 * 1)]       //
        stp x4, x5, [sp, #(16 * 2)]       //
        stp x6, x7, [sp, #(16 * 3)]       //
        stp x8, x9, [sp, #(16 * 4)]       //
        stp x10, x11, [sp, #(16 * 5)]     //
        stp x12, x13, [sp, #(16 * 6)]     //
        stp x14, x15, [sp, #(16 * 7)]     //
        stp x16, x17, [sp, #(16 * 8)]     //
        stp x18, x19, [sp, #(16 * 9)]     //
        stp x20, x21, [sp, #(16 * 10)]    //
        stp x22, x23, [sp, #(16 * 11)]    //
        stp x24, x25, [sp, #(16 * 12)]    //
        stp x26, x27, [sp, #(16 * 13)]    //
        stp x28, x29, [sp, #(16 * 14)]    //
        str x30, [sp, #(16 * 15)]         //
        
        mov x0, #0                       // unknown error ID
        bl exception_handler             // handle exception

        // TODO: refactor to macro
        ldp x0, x1, [sp]                  //
        ldp x2, x3, [sp, #(16 * 1)]       //
        ldp x4, x5, [sp, #(16 * 2)]       //
        ldp x6, x7, [sp, #(16 * 3)]       //
        ldp x8, x9, [sp, #(16 * 4)]       //
        ldp x10, x11, [sp, #(16 * 5)]     //
        ldp x12, x13, [sp, #(16 * 6)]     //
        ldp x14, x15, [sp, #(16 * 7)]     //
        ldp x16, x17, [sp, #(16 * 8)]     //
        ldp x18, x19, [sp, #(16 * 9)]     //
        ldp x20, x21, [sp, #(16 * 10)]    //
        ldp x22, x23, [sp, #(16 * 11)]    //
        ldp x24, x25, [sp, #(16 * 12)]    //
        ldp x26, x27, [sp, #(16 * 13)]    //
        ldp x28, x29, [sp, #(16 * 14)]    //
        ldr x30, [sp, #(16 * 15)]         //

        add sp, sp, #(32 * 8)             // deallocate stack storage

        eret                              // end unknown_error vector

irq_handler:                              // ***** handle hardware interrupt *****
        sub sp, sp, #(32 * 8)             // allocate storage for registers

        // TODO: refactor to macro
        stp x0, x1, [sp]                  //
        stp x2, x3, [sp, #(16 * 1)]       //
        stp x4, x5, [sp, #(16 * 2)]       //
        stp x6, x7, [sp, #(16 * 3)]       //
        stp x8, x9, [sp, #(16 * 4)]       //
        stp x10, x11, [sp, #(16 * 5)]     //
        stp x12, x13, [sp, #(16 * 6)]     //
        stp x14, x15, [sp, #(16 * 7)]     //
        stp x16, x17, [sp, #(16 * 8)]     //
        stp x18, x19, [sp, #(16 * 9)]     //
        stp x20, x21, [sp, #(16 * 10)]    //
        stp x22, x23, [sp, #(16 * 11)]    //
        stp x24, x25, [sp, #(16 * 12)]    //
        stp x26, x27, [sp, #(16 * 13)]    //
        stp x28, x29, [sp, #(16 * 14)]    //
        str x30, [sp, #(16 * 15)]         //

        mov x0, #2                        // hardware interrupt ID
        mrs x1, esr_el1                   // exception syndrome register EL1, get current exception info
        mrs x2, elr_el1                   // exception link register, get return address
        bl exception_handler              // handle exception

        // TODO: refactor to macro
        ldp x0, x1, [sp]                  //
        ldp x2, x3, [sp, #(16 * 1)]       //
        ldp x4, x5, [sp, #(16 * 2)]       //
        ldp x6, x7, [sp, #(16 * 3)]       //
        ldp x8, x9, [sp, #(16 * 4)]       //
        ldp x10, x11, [sp, #(16 * 5)]     //
        ldp x12, x13, [sp, #(16 * 6)]     //
        ldp x14, x15, [sp, #(16 * 7)]     //
        ldp x16, x17, [sp, #(16 * 8)]     //
        ldp x18, x19, [sp, #(16 * 9)]     //
        ldp x20, x21, [sp, #(16 * 10)]    //
        ldp x22, x23, [sp, #(16 * 11)]    //
        ldp x24, x25, [sp, #(16 * 12)]    //
        ldp x26, x27, [sp, #(16 * 13)]    //
        ldp x28, x29, [sp, #(16 * 14)]    //
        ldr x30, [sp, #(16 * 15)]         //

        add sp, sp, #(32 * 8)             // deallocate stack storage

        eret                              // return to previous execution

enable_irq:                               // ***** enable hardware interrupts *****
        msr daifclr, #2                   // clear IRQ bit in PSTATE
        ret                               // end enable_irq subroutine
