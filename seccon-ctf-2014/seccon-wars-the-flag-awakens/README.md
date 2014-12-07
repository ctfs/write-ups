# SECCON CTF 2014: SECCON Wars: The Flag Awakens

**Category:** QR
**Points:** 300
**Description:**

> <http://youtu.be/1pC56S17-_A>
>
> # Not need Japanese text to solve this task.
> # If you need it? see below :)
> <http://pastebin.com/uXByBZv5>

## Write-up

This weekend I played the SECCON CTF which was fun, but I struggled a lot on a particular challenge (crypto200 and couldn't solve it on time, which is sad) But I found QR300 really fun even if easy, that's why I would like to show you how I solved it.

So well, let's get started.

The challenge links us a youtube viedo: https://www.youtube.com/watch?v=1pC56S17-_A

A bunch of japanese stuff is displayed, but the utterance of the challenge told us that we weren't required to understand it. At 56 seconds from the start of the video, the SECCON logo stands in front of the text, and we can see a QRcode sliding in the background.

So, I recorded the frames of the video using VLC. To do so, you have to click on "tools" -> "preference" ; set the settings to "all" and in the section "Video", click "Filters" and enable "Scene video filter". Then under the "Filters" menu click "scene filter" to configure it.

I configured it to save every frame, and started to play the video at the begining of the appearance of the QRcode.

When this was done, I made a little python script to create an image combining the last line of pixels from every frame.

```python
import subprocess
from PIL import Image

if __name__ == "__main__":

    width = 400
    height = 300
    result = Image.new('RGBA', (width, height))

    img_list = subprocess.check_output(["ls", "./"]).split(b'\n')
    i = 0
    for img in img_list:
        if img[-4:] != b'.png':
            continue
        image = Image.open(img.decode('utf-8'))
        rgb_im = image.convert('RGB')
        for x in range(image.size[0]):
            for y in range(3):
                r, g, b = rgb_im.getpixel((x, image.size[1] - 1))
                result.putpixel((x, i + y),(r, g, b, 255))
        i += 3
    result.save("result.png")
```

Running this scripts in the same directory where the saved frames were gave me this picture :


![Result from script](https://github.com/Ark444/write-ups/blob/master/seccon-ctf-2014/seccon-wars-the-flag-awakens/result.png)

Which should scan properly with almost any QRcode reader, but I saw that some online QRcode reader couldn't read it (because of the colors I guess) so after a few Gimp manipulations, I ended up with this:

![Result modified](https://github.com/Ark444/write-ups/blob/master/seccon-ctf-2014/seccon-wars-the-flag-awakens/result2.png)

Flag is : SECCON{M4Y 7H3 F0RC3 83 W17H U}



## Other write-ups and resources

* none yet
