# DEF CON CTF Qualifier 2014: 3dttt

**Category:** Baby’s First
**Points:** 1
**Description:**

> Play well and play fast.
> `3dttt_87277cd86e7cc53d2671888c417f62aa.2014.shallweplayaga.me:1234`

## Write-up

In this challenge you had to beat LegitBS’s bot in a game of 3D Tic-Tac-Toe. You had to get to a balance of +50 games.

The following is a simple solution. Each position on the board is given a weight/score based on the number of lines that board position lies on. Beating the challenge was simply a case of selecting the available move with the greatest weight each time.

```python
import random
import socket

#Position weights (# of lines each position lies on)
weights = [
		   #Front layer
		   7, 4, 7,
		   4, 3, 4,
		   7, 4, 7,
		   
		   #Middle layer
		   4, 3, 4,
		   3, 8, 3,
		   4, 3, 4,
		   
		   #Back layer
		   7, 4, 7,
		   4, 3, 4,
		   7, 4, 7,
		  ]

#Current board state (1 if taken, 0 if not)
state = [
		 0, 0, 0,
		 0, 0, 0,
		 0, 0, 0,
		 
		 0, 0, 0,
		 0, 0, 0,
		 0, 0, 0,
		 
		 0, 0, 0,
		 0, 0, 0,
		 0, 0, 0,
		]

#Convert x,y,z co-ordinates to index
def indexFromCoords(zIn, yIn, xIn):
	return (int(zIn) * 9) + (int(yIn) * 3) + int(xIn)

#Convert index back to x,y,z co-ordinates string to submit as a move
def indexToCoords(iIn):
	zCoord = (iIn - (iIn % 9)) / 9
	i2d = (iIn - (zCoord * 9))
	yCoord = (i2d - (i2d % 3)) / 3
	xCoord = (i2d - (yCoord * 3))
	return str(xCoord) + "," + str(yCoord) + "," + str(zCoord) + "\n"

#Parse board state from service output
def parseBoard(output):
	global state
	
	#Parse output
	curZ = 0
	curY = -1
	for line in output.splitlines():
		curY = -1
		if "Let's play again" in line:
			#Reset state
			state = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
		if line.startswith(" x 0   1   2    z="):
			#Update current Z
			curZ = line[18:19]
		elif line.startswith("0"):
			curY = 0
		elif line.startswith("1"):
			curY = 1
		elif line.startswith("2"):
			curY = 2
		
		#If curY > -1 then parse out board state
		if curY > -1:
			#3:4, 7:8, 11:12 are positions of TTT pieces
			if line[3:4] == "X" or line[3:4] == "O":
				#X = 0 = not empty
				state[indexFromCoords(curZ, curY, 0)] = 1
			if line[7:8] == "X" or line[7:8] == "O":
				#X = 1 = not empty
				state[indexFromCoords(curZ, curY, 1)] = 1
			if line[11:12] == "X" or line[11:12] == "O":
				#X = 2 = not empty
				state[indexFromCoords(curZ, curY, 2)] = 1

#Find the available move with the greatest weight (randomly pick one if multiple of same weight)
def findMove():
	#Find highest possible weight
	maxWeight = 0
	for i in range(0, 27):
		if state[i] == 0 and weights[i] > maxWeight:
			maxWeight = weights[i]
	
	#Find all available moves of at least maxWeight
	potentialMoves = []
	for i in range(0, 27):
		if state[i] == 0 and weights[i] == maxWeight:
			potentialMoves.append(i)
	
	#Select random move from potential moves
	return random.choice(potentialMoves)

#Deets
target_host = "3dttt_87277cd86e7cc53d2671888c417f62aa.2014.shallweplayaga.me"
target_port = 1234
done = False

#Let's play a game...
#Connect, receive and print first chunk
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect((target_host, target_port))
print sock.recv(4096)

#Play first move - 1,1,1
sock.send("1,1,1\n")
print "1,1,1"

while done == False:
	try:
		#Receive a chunk of data
		data = sock.recv(4096)
		if not data:
			done = True
		else:
			print data
			
			#Parse the game state
			parseBoard(data)
			
			#Select a move
			move = findMove()
			
			#Play the move
			sock.send(indexToCoords(move))
			print indexToCoords(move)
			
	except socket.error:
		done = True

print "...Done?"
```

## Other write-ups

* (none yet)
