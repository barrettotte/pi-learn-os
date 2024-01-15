#ifndef _IRQ_H
#define _IRQ_H

#include "mmio.h"

#define CNTP_EL0        (0x40000040)
#define CNTP_STATUS_EL0 (0x40000060)

#define IRQ_BASIC_PENDING  (MMIO_BASE + 0xB200)
#define ENABLE_IRQS_1      (MMIO_BASE + 0xB210)
#define ENABLE_IRQS_2      (MMIO_BASE + 0xB214)
#define ENABLE_BASIC_IRQS  (MMIO_BASE + 0xB218)
#define DISABLE_IRQS_1     (MMIO_BASE + 0xB21C)
#define DISABLE_IRQS_2     (MMIO_BASE + 0xB220)
#define DISABLE_BASIC_IRQS (MMIO_BASE + 0xB224)

#endif
