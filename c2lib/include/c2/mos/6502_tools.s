/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once

//-------------------------------------------------------------------------------
// Tools
//-------------------------------------------------------------------------------

// Performs a series of optimized lda and sta without re-loading the same value twice. The format is address, data, address, data, ...
macro multipoke @data...
{
	if(data.size() & 1)
		c2_error("An even number of arguments expected");

	var stored
	for(size_t r=0; r<data.size() / 2; r++)
	{
		if(stored[r] == 0)
		{
			size_t i1 = r * 2;

			lda #data[i1+1]

			for(size_t l=r; l<data.size() / 2; l++)
			{
				size_t i2 = l * 2;

				if(stored[l] == 0 && data[i1+1] == data[i2+1])
				{
					sta data[i2+0]
					stored[l] = 1;
				}
			}
		}
	}
}

// memcpy/memmove without self-modifying code. Handles overlapping buffers. May use all registers, $fb, $fc, $fd, $fe. The strategy is size over speed.
macro memcpy @dst, @src, @size
{
			var tmp = $fb

			enum
			{
				forward  = 1,
				backward = 2,
				any      = 3,
			}dir = any;

			if(dst >= src && dst < src + size)
			{
				dir = backward;
			}
			else if(src >= dst && src < dst + size)
			{
				dir = forward;
			}

			// Calculate how large the unrolled code would be
			var unroll_size = ((src.bits() <= 8 ? 2 : 3) + (dst.bits() <= 8 ? 2 : 3)) * size
			var looped_size = 5 + (src.bits() <= 8 ? 2 : 3) + (dst.bits() <= 8 ? 2 : 3)

			if(size == 0 || src == dst)
			{
			}
			else if(unroll_size <= looped_size && (dir & backward))
			{
				rrepeat(size)
				{
					lda src + c2repeatcount
					sta dst + c2repeatcount
				}
			}
			else if(unroll_size <= looped_size && (dir & forward))
			{
				repeat(size)
				{
					lda src + c2repeatcount
					sta dst + c2repeatcount
				}
			}
			else if(size <= 127 && (dir & backward))
			{
				ldy #size - 1
:				lda src,y
				sta dst,y
				dey
				bpl -
			}
			else if(size <= 256 && (dir & forward))
			{
				ldy #0
:				lda src,y
				sta dst,y
				iny
				if(size != 256)
					cpy #size
				bne -
			}
			else if(size < 256 && (dir & backward))
			{
				ldy #size
:				lda src - 1,y
				sta dst - 1,y
				dey
				bne -
			}
			else if(size == 256 && (dir & backward))
			{
				ldy #size - 1	//255
:				lda src,y
				sta dst,y
				dey
				cpy #$ff
				bne -
			}
			else if(dir & forward)
			{
				var offset = 256 - (size & 255)

				multipoke tmp + 0, (src - offset) & 255, tmp + 1, (src - offset) >> 8, tmp + 2, (dst - offset) & 255, tmp + 3, (dst - offset) >> 8

				ldx #size >> 8
				ldy #offset

:				lda (tmp + 0),y
				sta (tmp + 2),y
				iny
				bne -
				cpx #0
				beq +
				dex
				inc tmp + 1
				inc tmp + 3
				jmp -
:
			}
			else if(dir & backward)
			{
				var offset = size & 255

				multipoke tmp + 0, (src + size - offset) & 255, tmp + 1, (src + size - offset) >> 8, tmp + 2, (dst + size - offset) & 255, tmp + 3, (dst + size - offset) >> 8

				ldx #size >> 8
				ldy #offset - 1

:				lda (tmp + 0),y
				sta (tmp + 2),y
				dey
				cpy #$ff
				bne -
				cpx #0
				beq +
				dex
				dec tmp + 1
				dec tmp + 3
				jmp -
:
			}
}

// memset without self-modifying code. May use all registers, $fb and $fc, The strategy is size over speed.
macro memset @dst, @value, @size
{
			var tmp = $fb

			// Calculate how large the unrolled code would be
			var unroll_size = (dst.bits() <= 8 ? 2 : 3) * size
			var looped_size = 5 + (dst.bits() <= 8 ? 2 : 3)

			if(size == 0)
			{
			}
			else if(unroll_size <= looped_size)
			{
				lda #value
				repeat(size)
				{
					sta dst + c2repeatcount
				}
			}
			else if(size <= 127)
			{
				lda #value

				if(size-1 != value)
					ldy #size - 1
				else
					tay

:				sta dst,y
				dey
				bpl -
			}
			else if(size < 256)
			{
				lda #value

				if(size != value)
					ldy #size
				else
					tay

:				sta dst - 1,y
				dey
				bne -
			}
			else if(size == 256)
			{
				lda #value

				if(0 != value)
					ldy #0
				else
					tay

:				sta dst,y
				iny
				bne -
			}
			else
			{
				var offset = 256 - (size & 255)

				multipoke tmp + 0, (dst - offset) & 255, tmp + 1, (dst - offset) >> 8

				lda #value

				if(size >> 8 != value)
					ldx #size >> 8
				else
					tax

				if(offset != value)
					ldy #offset
				else
					tay

:				sta (tmp + 0),y
				iny
				bne -
				cpx #0
				beq +
				dex
				inc tmp + 1
				jmp -
:
			}
}
