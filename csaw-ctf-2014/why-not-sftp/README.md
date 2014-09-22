# CSAW CTF 2014: why not sftp?

**Category:** Forensics
**Points:** 200
**Description:**

> well seriously, why not?
>
> Written by marc
>
> [traffic-5.pcap](traffic-5.pcap)

## Write-up

Download the file and open it with Wireshark. Filter the packet captures by FTP-DATA protocol by typing `ftp-data` into the filter box. Click the capture labeled number `413` and notice how the first few bytes matches the file header for ZIP files. To extract this ZIP file from the PCAP file, right click that capture and select `Follow TCP Stream`, which will open a new window with a lot of bytes. At the bottom, click the `Save As` button, and save it somewhere as a `*.zip` file. Unzip the file however you want and open the `flag.png` inside!

## Other write-ups

* none yet
