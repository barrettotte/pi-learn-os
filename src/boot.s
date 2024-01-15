        .section ".text.boot"
        .global _start
_start:                             // ***** entry point *****
        mrs x1, mpidr_el1           // system register (multiprocessor affinity register) to GPR
        and x1, x1, #3              // get core number
        cbz x1, pre_kernel          // enter kernel if using first core, otherwise stop other slave cores

halt:                               // ***** halt processor core *****
        wfe                         // wait for event (enter low-power state)
        b halt                      // infinite loop

pre_kernel:                         // ***** prepare before kernel entry *****
        mrs x0, currentel           // get current exception level
        lsr x0, x0, #2              //
        cmp x0, #2                  // check if at exception level 2
        bne halt                    // halt core, bad exception level

        msr sctlr_el1, xzr          // clear EL1 system control register
        mov x0, #(1 << 31)          // set 32nd bit
        msr hcr_el2, x0             // set execution state of EL1 to AArch64

        mov x0, #0b1111000101       // set PSTATE, last 4 bits (0101) is SP_EL1 mode
        msr spsr_el2, x0            // set EL2 saved program status register
        adr x0, el1_entry           // address to return to after switching to EL1
        msr elr_el2, x0             // load return address
        eret                        // return from exception

el1_entry:                          // 
        ldr x1, =_start             // 
        mov sp, x1                  // init stack pointer

        ldr x0, =vector_table       //
        msr vbar_el1, x0            // init vector base address register for EL1

        ldr x1, =__bss_start        // 
        ldr w2, =__bss_size         // 
bss_clear:                          // init stack segment data
        cbz w2, kernel_entry        // enter kernel if done clearing stack segment
        str xzr, [x1], #8           // store zero (8 bytes) at bss[x1], x1 += 8
        sub w2, w2, #1              // w2--
        cbnz w2, bss_clear          // continue clearing stack segment if w2 != 0

kernel_entry:                       // ***** enter kernel *****
        bl kmain                    // enter kernel main
        b halt                      // halt core just in case
