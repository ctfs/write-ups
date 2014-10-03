# CSAW CTF 2014: csaw2013reversing2.exe

**Category:** Reverse Engineering
**Points:** 200
**Description:**

> We got a little lazy so we just tweaked an old one a bit
>
> Written by HockeyInJune
>
> [csaw2013reversing2.exe](csaw2013reversing2.exe)

## Write-up

![alt tag](http://naper.eu/blog/content/public/upload/rever_0_o.png)
 

when i tried to debug the executable using ollydbg, i noticed a line containing "IsDebuggerPresent", i thought then that i should be using a win32 local debugger in order to get the correct flag, but it turns out it wasn't the case.

I continued debuging with Ollydbg using the step over option (F8).

At the address 004010A3 our program is calling the address 004010EF and then pushing -1. the program ends up by exiting without drawing any MessageBox.the trick behind this challenge was to assemble the address 004010A3 so that it jumps to 004010A5, then using the step over option we get a blank message box.

![alt tag](http://naper.eu/blog/content/public/upload/blankrev_0_o.png)

also assembling the address 004010B7 so that it jumps to 004010B9, once it arrives to the address 004010C4 you will get the flag

![alt tag](http://naper.eu/blog/content/public/upload/flag_0_o.png)

 

flag{reversing_is_not_that_hard!}


## Other write-ups

* <http://www.mrt-prodz.com/blog/view/2014/09/csaw-ctf-quals-2014---csaw2013reversing2exe-200pts-writeup>
