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
 

I opened it using ollydbg , and then i saw this line IsDebuggerPresent , i thought that i shoud open it using win 32 local debugger in IDA pro. and i will get the correct flag , but it wasn't the case . Then i run it using Ollydbg and i used the step over (F8) . On the adresse 0 040 10 A3 our program is calling the adresse 004010EF and this later is pushing -1 . then our program exit without drawing any MessageBox .

So what we have to do is assembling the adresse 0 040 10 A3 so that it jumped to the adresse 0 040 10 A5 , then using step over(F8) we wil get a blank message box .

![alt tag](http://naper.eu/blog/content/public/upload/blankrev_0_o.png)

and also assembling the adresse 0 040 10 B7 so that it jumped to 0 040 10 B9 and while arriving to the adresse 0 040 10 C4 you will get the flag :D .

![alt tag](http://naper.eu/blog/content/public/upload/flag_0_o.png)

 

flag{reversing_is_not_that_hard!}


## Other write-ups

* <http://www.mrt-prodz.com/blog/view/2014/09/csaw-ctf-quals-2014---csaw2013reversing2exe-200pts-writeup>
