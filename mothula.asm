pushpc

org $9EBF01 ; z_speed
db 2, -2

org $9EBF03 ; y_speed and x_speed
db -32, -24, 0, 24, 32, 24, 0, -24, -32, -24

org $9EBFD3 ; beam speeds
db -24, 0, 24
db 36, 48, 36

org $9EBD6E ; spike max speed and acceleration
db 64, -64, 0, 0, 64, -64
db 2, -2, 0, 0, 2, -2

pullpc
