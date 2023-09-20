# Smart-Contract-for-Tie-Breaking

Smart contract for breaking a tie between two users using a Rock-Paper-Scissors game using a commitment scheme and anti-cheating policies.
Developed for the "Introduction to Blockchains and Cryptocurrencies" course at the Faculty of Engineering, Alexandria University under the supervision of Prof. Dr. Ahmed Kosba

## Rock paper scissor game smart contract.
# Rules:

•	To participate in the game fairly, a 5ETH deposit has to be paid by both player 1 and player 2 to ensure that no party will attempt to cheat else they will lose their deposit

•	if draw,  distribute prize equally

•	If one wins, give total reward to the winner

•	Contract creator (manager) will deposit the reward after he creates the smart contract

•	If one player cheats or uses an invalid choice, he will both lose the reward and his deposit to the other player

•	If both player cheat or use invalid choices, both the reward and the deposits of each player will be sent to the manager as a penalty

•	If no cheating happens, both players are guaranteed to have their deposits back after every party reveals.

Algorithm:

First, limit entry for two different addresses

The two addresses are known to the contract in advance and hardcoded (as mentioned in the pdf requirement), neither can a different address from the 2 enter OR the same address enter twice.
Each player will use keccak256 input (choice concatenated with 32-bit nonce) and 5ETH deposit.
(You may find the arguments_to_keccak256 function useful, just give its arguments as choice (“rock”, “paper”, or “scissors” only are allowed) and a nonce and it will return a bytes32 keccak256 hash to be used as an argument to the choice function.
Must wait for both players to submit their input first.
Then for reveal function, both players must put as argument their originally chosen choices and nonces individually.
Immediately after the second player reveals his input, the smart contract will automatically check if a player has invalid input or has attempted cheated and will penalize the cheating party(ies) accordingly.
If all players have been proven to be not malicious, we start the rock paper scissors game
if both player pick the same choice, they will get half of the reward each,
If a player wins, the total reward will be transferred to that party
At this point, refund the deposits of both player back to them for correctly carrying out the game using the smart contract.
