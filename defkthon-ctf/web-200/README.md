# DEFKTHON CTF: Web 200

**Description:**

> [Auth Me In](http://54.201.96.212:888/web200/)

## Write-up

(TODO)

## Other write-ups

Web 200 – Defkthon 2014

With the hint [Web 200] Clue: Not SQL, we now know that it is deficiently not an sql injection that will help us. 
After searching on the Internet about injections that are not an sql injection, I came up with something called a nosql injection. 
A google search about nosql injection will lead you to this website: http://data.story.lu/2011/03/07/nosql-injection-in-mongo-php. 
A quick look at it and you will learn that, by appending [$ne] to the $_GET parameter, you can, instead make the query look for 
things that are ‘not equal’ to whatever you set the value to.

The final solution that resulted in the flag ‘flag{itoldunaathisisnotSQLinjection}’ was 
‘http://54.201.96.212:888/web200/?userid[$ne]=a&password[$ne]=a’
