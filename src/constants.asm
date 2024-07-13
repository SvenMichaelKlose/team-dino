num_sprites = 32

sprite_init_flags       = 0
sprite_init_x           = 1
sprite_init_y           = 2
sprite_init_color       = 3
sprite_init_gfx_l       = 4
sprite_init_gfx_h       = 5
sprite_init_ctrl_l      = 6
sprite_init_ctrl_h      = 7
sprite_init_dimensions  = 8
sprite_init_data        = 9
sprite_init_pgl         = 10
sprite_init_pgh         = 11

is_inactive    = 128
is_bubble      = 1

multiwhite  = multicolor + white

screen = $1e00
screen_columns = 28

; TODO: Charset – these are all fake to get it to assemble

background  = %11000000
framemask   = %10000000
foreground  = %01111111
last_priority_char = 23
