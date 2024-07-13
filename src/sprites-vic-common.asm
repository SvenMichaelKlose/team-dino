.include "vic.asm"
.include "constants.asm"
.include "sprite.imports.asm"

.importzp s, sl, sh
.importzp d, dl, dh
.importzp tmp, tmp2
.importzp scr, scrl, scrh

.import bricks
.import line_addresses_l, line_addresses_h

.import draw_huge_sprite

; TODO: check if n5/n is correct
draw_sprites:
    ldx #0
:   lda sprites_i,x
    bmi :+  ; Slot unused…
    sei
    jsr draw_huge_sprite
    cli
:   inx
    cpx #num_sprites
    bne :--

    ldx #num_sprites - 1
sprites_clear_loop:
    sei

    ; Make frame-related index into sprite tables.
    txa
    asl
    tay
    lda spriteframe
    bne :+
    iny
:   sty tmp

    ; Prepare 2-dimensional loop and address on screen.
    lda sprites_sh,y
    beq +not_dirty
    sta sprite_rows
    lda #0
    sta sprites_sh,y

    lda sprites_sy,y
    sta tmp2
    lda sprites_sx,y
    clc
    ldy tmp2
    adc line_addresses_l,y
    sta scrl
    lda line_addresses_h,y
    adc #0
    sta scrh

l2: ldy tmp
    lda sprites_sw,y
    tay

l3: lda (scr),y
    beq n5              ; Nothing to clear…
    and #foreground
    bne n5              ; Don't remove foreground chars…

    lda (scr),y
    and #framemask
    cmp spriteframe
    beq n5              ; Char belongs to sprite in current frame…

    ; Make pointer into brick map.
    lda scrl
    sta dl
    lda scrh
    ora bricks
    sta dh

    ; Check if DOH char
    lda (d),y
    and #background
    cmp #background
    bne n2              ; No. Just clear…
    lda (d),y           ; Restore DOH char.
    bne n3

n2: lda #0
n3: sta (scr),y

n5: dey
    bpl l3

    ; Step to next screen line.
    lda scr
    clc
    adc screen_columns
    sta scr
    bcs l5
n:  dec sprite_rows
    bne l2

not_dirty:
    cli
    dex
    bpl sprites_clear_loop

    rts

l5: inc scrh
    bne n  ; (jmp)

clear_screen_of_sprites:
    ldx #0
l:  lda screen,x
    jsr j
    sta screen,x
    lda 256 + screen,x
    jsr j
    sta 256 + screen,x
    cpx #76
    bcs :+
    lda 512 + screen,x
    jsr j
    sta 512 + screen,x
:   dex
    bne l
    rts

j:  tay
    and #foreground
    bne :+
    ; TODO: Restore DOH chars.
    ldy #0
:   tya
    rts
