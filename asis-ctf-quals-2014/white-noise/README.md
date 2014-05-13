# ASIS Cyber Security Contest Quals 2014: White noise

**Category:** Stego
**Points:** 175
**Description:**

> [file](steg_250_8be7a320b7cbc2696f352cb42e717a0b)

## Write-up

The file seems to be a tar.xz container (`file steg_250_8be7a320b7cbc2696f352cb42e717a0b`)
So we use 
`tar -xf steg_250_8be7a320b7cbc2696f352cb42e717a0b`

The new file we got seems to be a png (file)
Just a random noise picture
 when using pnginfo it tells us this
 
 `pnginfo steg_250_958a0ad74c8f0e07adb6c92672490b72`
 
 ```
 
 Image Width: 256 Image Length: 256
 Bitdepth (Bits/Sample): 8
 Channels (Samples/Pixel): 3
 Pixel depth (Pixel Depth): 24
 Colour Type (Photometric Interpretation): RGB
 Image filter: Single row per byte filter
 Interlacing: No interlacing
 Compression Scheme: Deflate method 8, 32k window
 Resolution: 0, 0 (unit unknown)
 FillOrder: msb-to-lsb
 Byte Order: Network (Big Endian)
 Number of text strings: 0 of 0
 ```	
 Nothing useful
 
 So I start looking at the pixels using a python script
 
``` 
from PIL import Image

im = Image.open("foto.png")
rgb_im = im.convert('RGB')
#size is 256 by 256
for x in xrange(0,255):
	for	y in xrange(0,255):
		
		r, g, b = rgb_im.getpixel((x, y))
		print str(r) + " " + str(g) + " " + str(b)
```				
		
	The output is as following
```	
R   G   B
128 80 239
128 171 83
128 165 100
128 136 219
128 165 161
128 68 224
128 119 60
```	
All the R's are 128, so probably not important.

When exporting all the G's and B's.


```
from PIL import Image

im = Image.open("foto.png")
rgb_im = im.convert('RGB')
#size is 256 by 256
for x in xrange(0,255):
	for	y in xrange(0,255):
		
		r, g, b = rgb_im.getpixel((x, y))
		print "(" str(g) + ";" + str(b) + ")"
```				
		
It gives us this kind of output.
```	
(80;239)
(171;83)
(165;100)
(136;219)
(165;161)
(68;224)
(119;60)
(171;162)
```	

when using the first 10000 points as coordinates on a scatter-plot(I used excel 2013), this becomes visible.

![alt tag](http://i.imgur.com/OGxqt6T.png)

When rotating this picture the flag becomes visible.

`ASIS_329afbd5ba6fc8b1df15e886edbdcc25`

Only 4 teams solved this one.



 
 

## Other write-ups

* none yet
