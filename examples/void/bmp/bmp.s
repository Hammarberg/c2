#include "c2/c2.s"

			// Render a BMP image using c2
			
#define dist(x1,y1,x2,y2) sqrt(((x1)-(x2))*((x1)-(x2))+((y1)-(y2))*((y1)-(y2)))

			macro byte @n
			{
				push8(n);
			}
			macro word @n
			{
				push16le(n);
			}
			macro dword @n
			{
				push32le(n);
			}

			@ = 0

			const int WIDTH = 1024;
			const int HEIGHT = 512;

head:
			byte 'B'
			byte 'M'
			dword end-head	// Full size
			dword 0	// App specific
			dword bitmap-head	// Offset to bitmap data
dib_head:
			dword bitmap-dib_head	//DIB header size
			dword WIDTH
			dword HEIGHT
			word 1	// Color planes
			word 24	// Bits per pixel
			dword 0	//BI_RGB
			dword end-bitmap	//Bitmap data size
			dword 2835	//Pixels/m X
			dword 2835	//Pixels/m Y
			dword 0	// Num colors in palette
			dword 0	// Important colors, 0 means all are
bitmap:
			for(int y = HEIGHT - 1; y>=0; y--)
			{
				for(int x = 0; x<WIDTH; x++)
				{
					double fr = sin(dist(x,y,WIDTH/2,0)/20);
					double fg = sin(dist(x,y,WIDTH/2,HEIGHT/2)/20);
					double fb = sin(dist(x,y,0,HEIGHT/2)/20);

					byte int(128+128*fb)
					byte int(128+128*fg)
					byte int(128+128*fr)
				}

				// Padding
				if((WIDTH*3)&3)
				{
					repeat(4-((WIDTH*3)&3))
					{
						byte 0
					}
				}
			}
end:
