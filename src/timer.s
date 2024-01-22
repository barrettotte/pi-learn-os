        .section .text

        .global enable_timer              // void enable_timer()
        .global get_timer_freq            // void get_timer_freq()
        .global set_timer_interval        // void set_timer_interval(uint32_t interval)
        .global get_timer_status          // void get_timer_status()

get_timer_freq:                           // ***** fetch timer frequency *****
        mrs x0, CNTFRQ_EL0                //
        ret                               // end get_timer_freq subroutine

get_timer_status:                         // ***** fetch timer status *****
        mrs x0, CNTP_CTL_EL0              //
        ret                               // end get_timer_status subroutine

set_timer_interval:                       // ***** set timer interval *****
        msr CNTP_TVAL_EL0, x0             //
        ret                               // end set_timer_interval subroutine

enable_timer:                             // ***** enable generic timer *****
        stp x29, x30, [sp, #-16]!         // save registers

        bl get_timer_freq                 // fetch timer frequency into x0
        mov x1, #100                      // 100 -> fire interrupt every 10ms
        udiv x0, x0, x1                   // timer interval
        bl set_timer_interval             // set timer interval

        mov x0, #1                        //
        msr CNTP_CTL_EL0, x0              // enable timer

        ldp x29, x30, [sp], #16           // restore registers
        ret                               // end enable_timer subroutine
