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
        ldr x1, =_start             // 
        mov sp, x1                  // init stack pointer

        ldr x1, =__bss_start        // 
        ldr w2, =__bss_size         // 
bss_fill:                           // init stack segment data
        cbz w2, kernel_entry        // enter kernel if done filling stack segment
        str xzr, [x1], #8           // store zero (8 bytes) at bss[x1], x1 += 8
        sub w2, w2, #1              // w2--
        cbnz w2, bss_fill           // continue filling stack segment if w2 != 0

kernel_entry:                       // ***** enter kernel *****
        bl main                     // enter kernel main, should not return
        b halt                      // halt core just in case
