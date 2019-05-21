#define REG_BASE_GPIO5                          (0xF8004000)

.globl bl1_entrypoint

/*light green led*/

bl1_entrypoint:
        ldr     x1, =REG_BASE_GPIO5 /* GPIO5 will no power off when suspending */
        ldr     w2, [x1, #0x400]
        mov     w3, #0x1
        orr     w2, w2, w3, LSL #1
        str     w2, [x1, #0x400]
        mov     w2, #0
        str     w2, [x1, #0x8]
