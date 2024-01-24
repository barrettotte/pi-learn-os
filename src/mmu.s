        .section .text

        .global enable_mmu
        .global setup_vm
        .global load_pgd

        .equ MAIR_ATTR, (0x44 << 8)
        .equ TCR_T0SZ,  (16) 
        .equ TCR_T1SZ,  (16 << 16)
        .equ TCR_TG0,   (0 << 14)
        .equ TCR_TG1,   (2 << 30)
        .equ TCR_VALUE, (TCR_T0SZ | TCR_T1SZ | TCR_TG0 | TCR_TG1)
        .equ PAGE_SIZE, (2*1024*1024)

load_pgd:                                 // ***** TODO:
        msr ttbr0_el1, x0                 // load for user space translation

        // invalidate tlb entries and synchronize the context

        tlbi vmalle1is                    // TODO:
        dsb ish                           // TODO:
        isb                               // TODO:

        ret                               // end load_pgd subroutine

enable_mmu:                               // ***** enable MMU *****
        adr x0, pgd_ttbr1                 // load pointer to translation table 0
        msr ttbr1_el1, x0                 // set translation table 0 for kernel space
        adr x0, pgd_ttbr0                 // load pointer to translation table 1
        msr ttbr0_el1, x0                 // set translation table 1 for user space

        ldr x0, =MAIR_ATTR                // 
        msr mair_el1, x0                  // set memory attribute indirection register EL1
        ldr x0, =TCR_VALUE                // sets base address register for translation table mapping
        msr tcr_el1, x0                   // set translation control register EL1

        mrs x0, sctlr_el1                 //
        orr x0, x0, #1                    // set bit 1 to enable MMU
        msr sctlr_el1, x0                 // set system control register EL1
    
        ret                               // end enable_mmu subroutine

setup_vm:                                 // 
setup_kvm:                                // ***** map kernel space *****
        adr x0, pgd_ttbr1                 // global directory table address
        adr x1, pud_ttbr1                 // upper directory table address
        orr x1, x1, #3                    // TODO:
        str x1, [x0]                      // set PGD[0] = first entry of PUD

        adr x0, pud_ttbr1                 // upper directory table address
        adr x1, pmd_ttbr1                 // middle directory table address
        orr x1, x1, #3                    // TODO:
        str x1, [x0]                      // set PUD[0] = first entry of PMD

        mov x2, #0x34000000               // end of kernel
        adr x1, pmd_ttbr1                 // middle directory table address
        mov x0, #(1<<10 | 1<<2 | 1<<0)    // TODO:
_kvm_l1:                                  // map each 2MB physical page
        str x0, [x1], #8                  // set memory attributes and type
        add x0, x0, #PAGE_SIZE            // advance to next page address
        cmp x0, x2                        // check if at memory end
        blo _kvm_l1                       // keep mapping memory if not at memory end

_kvm_peripheral:                          // map peripheral memory
        mov x2, #0x40000000               // peripheral virtual memory
        mov x0, #0x3f000000               // peripheral physical memory

        adr x3, pmd_ttbr1                 // load pointer to middle directory table
        lsr x1, x0, #(21 - 3)             // shift by 2MB (2^21) - 3 (offset of entry; 8 bytes)
        add x1, x1, x3                    // base table address + entry offset

        orr x0, x0, #1                    // set memory attributes
        orr x0, x0, #(1 << 10)            // set memory type to device memory
_kvm_l2:                                  //
        str x0, [x1], #8                  // set memory attributes and type
        add x0, x0, #PAGE_SIZE            // advance to next page address
        cmp x0, x2                        // check if at device memory end
        blo _kvm_l2                       // keep mapping memory if not at device memory end

        adr x0, pud_ttbr1                 // upper directory table address
        add x0, x0, #8                    // TODO:
        adr x1, pmd2_ttbr1                // TODO:
        orr x1, x1, #3                    // TODO:
        str x1, [x0]                      // set PUD[1] = PMD2

        mov x2, #0x41000000               // end
        mov x0, #0x40000000               // start (timers)

        adr x1, pmd2_ttbr1                // TODO:
        orr x0, x0, #1                    // TODO:
        orr x0, x0, #(1 << 10)            // TODO:
_kvm_l3:                                  //
        str x0, [x1], #8                  // set memory attributes and type
        add x0, x0, #PAGE_SIZE            // advance to next page address
        cmp x0, x2                        // check if more pages to set
        blo _kvm_l3                       // continue setting memory

setup_uvm:                                // map user space virtual memory
        adr x0, pgd_ttbr0                 // load pointer to PGD
        adr x1, pud_ttbr0                 // load pointer to PUD
        orr x1, x1, #3                    // bit 0 = valid entry, bit 1 = points to next level page table
        str x1, [x0]                      // set PGD[0] = first entry of PUD; only entry we need on PGD

        adr x0, pud_ttbr0                 // load pointer to PUD
        adr x1, pmd_ttbr0                 // load pointer to middle directory table (PMD)
        orr x1, x1, #3                    // bit 0 = valid entry, bit 1 = points to next level page table
        str x1, [x0]                      // set PUD[0] = first entry of PMD

        adr x1, pmd_ttbr0                 // load pointer to PMD
        mov x0, #(1<<10 | 1<<2 | 1<<0)    // set memory attributes; TODO:
        str x0, [x1]                      // set PMD[0] = 2MB page of physical memory

        ret                               // end setup_kvm subroutine

        .balign 4096                      // align 4KB
pgd_ttbr1:                                // kernel global directory table (PGD)
        .space 4096                       // 512 entries, each entry represents 512GB (only implement lower 1 GB)
pud_ttbr1:                                // kernel upper directory table (PUD)
        .space 4096                       // each entry represents 1GB
pmd_ttbr1:                                // kernel middle directory table (PMD)
        .space 4096                       // each entry points to 2MB physical pages
pmd2_ttbr1:                               //
        .space 4096                       //

pgd_ttbr0:                                // user global directory table (PGD)
        .space 4096                       //
pud_ttbr0:                                // user upper directory table (PUD)
        .space 4096                       //
pmd_ttbr0:                                // user middle directory table (PMD)
        .space 4096                       //
