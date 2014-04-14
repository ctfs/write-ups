# Plaid CTF 2014: graphs

**Category:** Crypto
**Points:** 200
**Description:**

> In this era, block ciphers hadn't even been invented. The Plague created [this system](graphs-0011fa3a98e9d40d4a671807eb817ca0.tar.bz2) based on problems he knew to be NP hard, but there must be something you can do to decode his messages.

## Write-up

So, first of all, what are our files?

* Ciphertext - encoded array of 1024 big numbers.
* Plaintext - the sum of 64 number from CT.
* Public key - encoded graph (list of lists).
* Private key - indexes of numbers in CT, which generate a plaintext.

So we have the public key with 1024 vertices, but we need only 64 from them.

Let's take a closer look at keygen function.

```
vertices = range(self.keylen)
privkey = random.sample(vertices,self.keylen>>4)
#privkey = random 64 vertices

tocover = set(vertices).difference(set(privkey))
#tocover = all others vertices

G = [0]*self.keylen
for v in vertices:
  G[v] = []
#just graph init

#!!! the most important part !!!
while len(tocover) > 0:
  src = random.choice(privkey)
  dst = random.choice(list(tocover))
  G[src].append(dst)
  G[dst].append(src)
  tocover = tocover.difference(set([dst]))
```

So len(tocover) = 1024 - 64 = 960.
We take 2 random vertices, 1 from privkey, 1 from `tocover` set and "connecting" them.
We can compute lengths of privkeys vertices(count of connected element) = 960 / 64 = 15(will be same for all keylen).
Now we know, that our `privkey` vertices have 15 element, but what with others?

```
others = list(set(vertices).difference(set(privkey)))
for o in others:
  for n in others:
    if random.getrandbits(5) == 0:
      if o not in G[n]:
        G[n].append(o)
        G[o].append(n)
```

We connect two vertices `o` and `n` only in 1/32 cases. But our graph is symmetric, so indeed in 1/16 case. Okay, so for every vertice `o` we have about 960/16=60 connected elements versus 15 elements in private key.

Now we need only get indexes of 64 vertices with smallest count of connected elements. I made it in this way:

```
privkey = []
for index, el in enumerate(self.pubkey):
  if len(el) <= 30:
    privkey.append(index)
self.privkey = privkey
```

Decrypt our CT => 
2275629599429195325551385405029036171782046085131052214556340540961662 =>
The flag is: 3veryb0dy_poops~




## Other write-ups

* none yet
