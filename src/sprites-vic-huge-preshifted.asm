.importzp tmp, tmp2, tmp3, tmp4
.importzp s, sl, sh
.importzp d, dl, dh
.importzp sprite_lines
.importzp sprite_cols

.import add_sb, add_db
.import _blit_left_loop, _blit_right_loop
.import blit_left_addr, blit_right_addr
.import negate7

; Preshift sprite graphics for a sprite.
;
; A: Number of bits to shift.
; tmp: Sprite dimensions (00YYYXXX)
;    X: width of X axis
;    Y: height of Y axis
; s: Graphics address
; d: Destination address
;
; X remains untouched.
.proc preshift_huge_sprite_one_offset
    ; Configure the blitter.
    sta blit_left_addr + 1
    tay
    lda negate7,y
    sta blit_right_addr + 1

    ; Determine dimensions.
    lda tmp4
    tay
    and #%00000111
    sta sprite_cols
    tya
    and #%00111000
    sta sprite_lines

    ; Draw left half of sprite column.
l:  ldy sprite_lines
    dey
    jsr _blit_right_loop
    jsr step_to_next_shifted_column

    ; Check if we have to draw a right column.
    lda blit_left_addr + 1
    beq n          ; No, not shifting…

    ldy sprite_lines
    dey
    jsr _blit_left_loop
    dec sprite_cols
    beq step_to_next_shifted_column
    bne n2

n:  dec sprite_cols
    beq done

    ; Step to next sprite column.
n2: lda sprite_lines
    jsr add_sb
    jmp l

step_to_next_shifted_column:
    lda sprite_lines
    jmp add_db

done:
    rts
.endproc

; Shift sprite graphics of a sprite for all offsets.
;
; Destination must be zeroed out beforehand.
;
; Will shift 4 times for multicoloured sprites and 8 times
; for hires ones.
;
; X: hires (0)/multicolor (not 0)
; Y: Sprite dimensions (lower octet is number of chars for X axis,
;    next octet is Y axis)
; s: Sprite graphics
; d: Destination address
.export preshift_huge_sprite
.proc preshift_huge_sprite
    sty tmp4

    lda sl
    sta tmp
    lda sh
    sta tmp2

    ldy #0
l:  lda tmp
    sta sl
    lda tmp2
    sta sh
    sty tmp3
    tya
    jsr preshift_huge_sprite_one_offset

    ldy tmp3
    iny
    txa
    beq n          ; Hires, step on a single bit.
    iny            ; Multicolor, step two bits.
n:  cpy #8
    bne l

done:
    rts
.endproc
