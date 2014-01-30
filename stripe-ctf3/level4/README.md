# Stripe CTF3: level4

## Description

Last night, your master MySQL database fell over in the middle of the night, causing you to wake up and perform an emergency failover. In the meanwhile, your entire site was down, relying on your sleepy self to remember and run the correct sequence of commands.

This has you thinking: there's got to be a better way. You know that there are [lots](http://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf) [of](http://docs.mongodb.org/manual/replication/) [systems](http://www.datastax.com/docs/1.0/cluster_architecture/replication) [out](http://zookeeper.apache.org/doc/r3.1.2/zookeeperInternals.html) [there](https://github.com/coreos/etcd) which provide automatic failover and high-availability. Why can’t you have that for your MySQL database too?

Starting today, you can.

In this level, your goal is to build a multi-node [highly-available](http://www.firstsql.com/highavailability.html) SQL database that behaves identically to a single node, even in the presence of network or node failures.

We’ve given you [starter code for such a database](https://github.com/ctfs/write-ups/tree/master/stripe-ctf3/level4/problem), written in [Go](http://golang.org/). The database uses a home-grown failover scheme, which it turns out doesn’t work very well in practice.

You’ll likely find [`README.md`](https://github.com/ctfs/write-ups/blob/master/stripe-ctf3/level4/problem/README.md) to be helpful in getting your bearings.

To actually test how your code handles failure scenarios, `test/harness` uses our network simulator, [Octopus](https://github.com/stripe-ctf/octopus), which will spin up your nodes and proxy their communication (acting as a [lossy network](http://www.dataexpedition.com/support/notes/tn0021.html)). Octopus will then start issuing SQL queries to all nodes at once, checking at each step to make sure your output looks exactly like what it gets by running the same queries locally.

## Write-up

The hard part of distributed databases really comes down to state replication — given one server that’s received a write request, how does it make sure the other servers know about that write before it’s accepted? Fortunately, there are a number of algorithms for this, such as [Paxos](http://research.microsoft.com/en-us/um/people/lamport/pubs/paxos-simple.pdf) and [Raft](https://ramcloud.stanford.edu/wiki/download/attachments/11370504/raft.pdf).

One solution would be to add [the Go implementation of the Raft distributed consensus protocol](https://github.com/goraft/raft) to [the provided starter code](https://github.com/ctfs/write-ups/tree/master/stripe-ctf3/level4/problem).

(TODO)

## Other write-ups or solutions

* <http://muehe.org/posts/stripe-ctf-3-writeup/>
* <https://github.com/henrik-muehe/level4>
* <https://github.com/metcalf/ctf3/tree/master/level4>
* <http://tullo.ch/articles/stripe-ctf-golfing/>
