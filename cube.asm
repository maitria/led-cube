		processor 6502

		org $0400

start:
	jsr emit_layer
	brk

output_port	equ $c010
data_bit	equ $01
shift_bit	equ $02
light_bit	equ $04

cube_memory	ds 64, $0f		; Bit-mapped "video memory"

emit_layer subroutine
	sta .save_a
	stx .save_x
	lda #0			; Turn off lights
	sta output_port

	ldx #0
.ebyte
	lda cube_memory,x
	jsr emit_byte

	inx
	cpx #8
	bne .ebyte

	lda #light_bit		; Light it back up
	sta output_port

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

