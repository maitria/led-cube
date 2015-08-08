	processor 6502
	org $0400
start:
wait1:	dec 0
	bne wait1
	dec 1
	bne wait1
	dec 2
	lda 2
	lsr
	lsr
	sta $c010
	jmp wait1
