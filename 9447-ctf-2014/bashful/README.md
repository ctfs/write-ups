# 9447 CTF 2014: bashful

**Category:** Web
**Points:** 101
**Description:**

> You think that was too easy? Well it was actually harder than I thought, so I made it simple again…
>
> [bashful.9447.plumbing](http://bashful.9447.plumbing/)

## Write-up

This is similar to tumorous. Going to bashful.9447.plumbing there is a mention about learning git and hiding token. Git repositories have a .git folder where information about the repository is stored.

So we browse to [bashful.9447.plumbing/.git/](http://bashful.9447.plumbing/.git/) and see the .git/logs/HEAD file. It says 

````
0000000000000000000000000000000000000000 3c4992205aba2077cbf87fc7cde900fabecd1140 root <root@ip-172-31-10-205.ap-southeast-2.compute.internal> 1412673432 +0000commit (initial): Hurr durr
3c4992205aba2077cbf87fc7cde900fabecd1140 ec972f9af79a09129021a30e7f08099aa2b8a81d John Doe <fsck@you.me> 1412673456 +0000	commit (amend): Hurr durr
ec972f9af79a09129021a30e7f08099aa2b8a81d 0b4d6fe0adf809c4e7b7a0d47132600b68f79fda root <root@ip-172-31-10-205.ap-southeast-2.compute.internal> 1417230572 +0000commit: My precious flag now exists
````

Someone did commit the flag but they've probably deleted it now. So we look at the .git/objects directory to see if any commit objects can be found. There seems to be none. 

They might have packed the commit objects. Let's look at .git/objects/info/packs . 
```
I banish thee, evil mind readers from planet Zblaargh. 
```

<hr>
In the initial version of the challenge we were supposed to find the pack name on our own by directly entering its url. Pack names are formed like pack-<SHA1>.<pack,idx> where <SHA1> is a hash of the sorted object names to make the resulting filename based on the pack content.

Unfortunately there was no (?) way to find out the object name of the token file without knowing the token itself? Anyhow, no team could solve this challenge at that difficulty level. And that's why the organizers reduced the complexity from 310 to 101 points and made the directories browseable.

<hr>

Okay, maybe we can just fetch the pack from the packs directory. .git/objects/pack
````
pack-deff83d57714493c6d317394f3542da8e396f887.idx
pack-deff83d57714493c6d317394f3542da8e396f887.pack
````

Fine, now we need to unpack the pack file. An easy way out was to refer to [this SO answer](http://stackoverflow.com/a/3333428/589184) and create an alias git unpack-refs.

On unpacking, `git status` shows
````
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	deleted:    index.html
	deleted:    token
````

Easy now. Do 
````
$ git checkout token
$ cat token
9447{I_JUST_THINK_BITCOIN_WILL_DIE_OUT_SOON}
````

## Other write-ups and resources

* none yet
