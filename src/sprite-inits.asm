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
is_doh_obstacle = 64
is_laser       = 16
is_ball        = 8
is_obstacle    = 4
is_bonus       = 2
is_vaus        = 1

multiwhite  = multicolor + white

dragon_init:
    is_vaus
    0 0 @(+ 128 multiwhite)
    <gfx_vaus >gfx_vaus
    <ctrl_vaus >ctrl_vaus
    10 0 0 0
