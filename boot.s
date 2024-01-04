         .section .text

         .global _start               // export entry point symbol
         .org 0x80000                 // set entry point

_start:                               // ***** entry point *****
          mrs x0, mpidr_el1           // system register (multiprocessor affinity register) to GPR
          and x0, x0, #3              // get core number
          cmp x0, #0                  // check if first core
          beq kernel_entry            // enter kernel if using first core

halt:                                 // ***** halt processor *****
          wfe                         // wait for event (enter low-power state)
          b halt                      // hang processor (infinite loop)

kernel_entry:                         // ***** enter kernel *****
          mov sp, #0x80000            // init stack
          bl kernel_main              // enter kernel main (main.c)
          b halt                      // hang
