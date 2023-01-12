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
			const int HEIGHT = 1024;

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
			const double MAX = dist(0,0,WIDTH,HEIGHT);
			for(int y = HEIGHT - 1; y>=0; y--)
			{
				for(int x = 0; x<WIDTH; x++)
				{
					double fr = dist(x,y,WIDTH,0) / MAX;
					double fg = dist(x,y,WIDTH,HEIGHT) / MAX;
					double fb = dist(x,y,0,HEIGHT) / MAX;

					byte int(255*(fb/1))	//B
					byte int(255*(fg/1))	//G
					byte int(255*(fr/1))	//R
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
