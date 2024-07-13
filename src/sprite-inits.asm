.include "vic.inc"
.include "constants.inc"

dragon_init:
    .byte is_bubble
    .byte 0     ; initial X
    .byte 0     ; initial >
    .byte 128 + multiwhite  ; color
    .word 0     ; original graphics
    .word 0     ; controller
    .byte 10    ; dimensions
    .byte 0     ; controller data
    .byte 0, 0  ; pre-shifted graphics
