		processor 6502

		org $0400

start:
	jsr emit_layer
	jsr emit_bit_pause
	jsr emit_bit_pause
	jsr emit_bit_pause
	jsr emit_bit_pause
	jsr emit_bit_pause
	jmp start

output_port	equ $c010
data_bit	equ $01
shift_bit	equ $02
light_bit	equ $04

cube_memory	.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff	; Bit-mapped "video memory"
		.byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
		.byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
		.byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
		.byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
		.byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
		.byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
		.byte $00, $00, $00, $00, $00, $00, $00, $00

current_layer	.byte $1
current_offset	.byte $0

emit_layer subroutine
	sta .save_a
	stx .save_x
	lda #0			; Turn off lights
	sta output_port

	ldx current_offset
	txa
	adc #8
	sta current_offset
.ebyte
	lda cube_memory,x	; Send layer bytes (anodes)
	jsr emit_byte
	inx
	cpx current_offset
	bne .ebyte

	lda current_layer 	; Send layer enables (cathodes)
	jsr emit_byte

	lda #light_bit		; Light it back up
	sta output_port

	asl current_layer	; increment current layer
	bcc .no_layer_wrap

	lda #1			; reset to first layer
	sta current_layer
	lda #0
	sta current_offset
.no_layer_wrap

	ldx .save_x
	lda .save_a
	rts
.save_a .byte
.save_x	.byte

emit_byte subroutine
	sta .work_byte
	sty .save_y
	ldy #0
.ebit
	and #data_bit
	sta output_port
	jsr emit_bit_pause

	ora #shift_bit
	sta output_port
	jsr emit_bit_pause

	and #($ff - shift_bit)
	sta output_port
	jsr emit_bit_pause

	lda .work_byte
	lsr
	sta .work_byte

	iny
	cpy #8
	bne .ebit

	ldy .save_y
	rts
.save_y		.byte
.work_byte	.byte
	
emit_bit_pause subroutine
	pha
	lda #$ff
	sta 0
	sta 1
.wait1
	dec 0
	bne .wait1
	dec 1
	bne .wait1
	pla
	rts
