.global delay
.global set_word
.global get_word
.global memset
.global memcmp
.global memcpy
.global memmove
.global get_el

// *****************************************************************************
// void delay(uint64_t cycles)
//
// delay system for given amount of cycles
// *****************************************************************************
delay:                  //
    subs x0, x0, #1     // arbitrary instruction to spend cycles
    bne delay           // keep delaying if x0 > 0
    ret                 // end delay

// *****************************************************************************
// void set_word(uint64_t addr, uint32_t word)
//
// set word at address
// *****************************************************************************
set_word:               //
    str w1, [x0]        // store word at address
    ret                 // end set_word

// *****************************************************************************
// uint32_t get_word(uint64_t addr)
//
// fetch word at address
// *****************************************************************************
get_word:               //
    ldr w0, [x0]        // load word from address
    ret                 // end get_word

// *****************************************************************************
// void memset(void* dst, int value, unsigned int size)
//
// set block of memory to given value
// *****************************************************************************
memset:                 //
    cmp x2, #0          // check size == 0
    beq _memset_end     // go to end if no memory left to set
_memset_set:            //
    strb w1, [x0], #1   // store value at addr and increment pointer
    subs x2, x2, #1     // size--
    bne _memset_set     // while size != 0, continue setting memory
_memset_end:            //
    ret                 // end memset

// *****************************************************************************
// void memcmp(void* a, void* b, unsigned int size)
//
// compare two blocks of memory
// *****************************************************************************
memcmp:                 //
    mov x3, x0          // move a
    mov x0, #0          //
_memcmp_cmp:            //
    cmp x2, #0          // check size == 0
    beq _memcmp_end     // go to end if no memory left to compare

    ldrb w4, [x3], #1   // load a[size]
    ldrb w5, [x1], #1   // load b[size]
    sub x2, x2, #1      // size--
    cmp w4, w5          // compare a[size] to b[size]
    beq _memcmp_cmp     // if a[size] == b[size], keep comparing memory

    mov x0, #1          // bytes are not equal
_memcmp_end:            //
    ret                 // end memcmp

// *****************************************************************************
// void memcpy(void* dst, void* src, unsigned int size)
//
// copy block of memory from source to destination. 
// memmove is essentially an alias to memcpy.
// *****************************************************************************
memcpy:                 //
memmove:                // memcpy and memove same implementation
    cmp x2, #0          // check size == 0
    beq _memcpy_end     // go to end if no memory to move

    mov x4, #1          // address incrementer

    cmp x1, x0          // check if dst starts after src to handle overlap
    bhs _memcpy_copy    // if dst >= src, then copy memory normally

    add x3, x1, x2      // last position of source
    cmp x3, x0          // check if end of src is in the middle of dst to handle overlap
    bls _memcpy_copy    // if memory is not overlapped, copy memory normally

_memcpy_overlap:        // handle overlapped memory, copy from high addr to low addr
    sub x3, x2, #1      // size of memory to copy
    add x0, x0, x3      // start at end of dst
    add x1, x1, x3      // start at end of src
    neg x4, x4          // flip sign to decrement src and dst pointers, copying backward

_memcpy_copy:           // copy from src to dst
    ldrb w3, [x1]       // get dst[size]
    strb w3, [x0]       // set src[size] = dst[size]
    add x0, x0, x4      // advance source pointer
    add x1, x1, x4      // advance destination pointer
    subs x2, x2, #1     // size--
    bne _memcpy_copy    // while size != 0, keep copying memory

_memcpy_end:            //
    ret                 // end memcpy

// *****************************************************************************
// unsigned char get_el()
//
// fetch current exception level
// *****************************************************************************
get_el:                //
    mrs x0, currentel  // get system register - exception level
    lsr x0, x0, #2     // get current exception level at bits 2-3
    ret                // end get_el
