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

The description to the write-up hints that the challenge is just a modified version of the csaw reversing challenge 2 of last year. 
Googleing for some write-ups I found out the the previous version contained an encrypted flag which got decrypted inside a debugger trap.

Running the file gives us a dialog box with "Flag" as caption and then some random bytes. So the challenge probably still has an encrypted flag which needs to be decrypted.

![](flag_encrypted.png)


Opening the file in IDA we indeed see two flows. One creates a dialog box (on the left), one creates a debugger trap and decrypts the flag (on the right).

![](two_flows.png)

We want to patch the file so it runs the decryption and then the dialog box.

This can be done by:

1. Replace `jz short loc_4010B9` with `jmp short loc_401096` 
2. Replace `jmp short loc_4010EF` with `jmp short loc_4010B9`
3. Replace the `ìnc ECX` and `int 3` instructions in the debugger trap with `NOP`

After doing this we get the patched file [csaw2013reversing2_patched.exe](csaw2013reversing2_patched.exe)

Running this patched executable gives us a dialog box with the flag:

![](flag_decrypted.png)


## Other write-ups

* <http://www.mrt-prodz.com/blog/view/2014/09/csaw-ctf-quals-2014---csaw2013reversing2exe-200pts-writeup>