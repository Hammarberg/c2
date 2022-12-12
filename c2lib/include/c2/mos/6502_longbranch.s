#pragma once

// Long branch

macro lbpl @n {
	bmi .b
	jmp n
.b:
}

macro lbmi @n {
	bpl .b
	jmp n
.b:
}

macro lbvc @n {
	bvs .b
	jmp n
.b:
}

macro lbvs @n {
	bvc .b
	jmp n
.b:
}

macro lbcc @n {
	bcs .b
	jmp n
.b:
}

macro lbcs @n {
	bcc .b
	jmp n
.b:
}

macro lbne @n {
	beq .b
	jmp n
.b:
}

macro lbeq @n {
	bne .b
	jmp n
.b:
}
