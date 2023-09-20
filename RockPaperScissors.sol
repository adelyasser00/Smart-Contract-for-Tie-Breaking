// Adel Yasser Yassin 6848 2)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract RockPaperScissors{
    address public player1 = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address public player2 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    address payable public manager;
    uint public reward;
    bool public ended;
    string public choice1;
    string public nonce1;
    string public choice2;
    string public nonce2;
    bool public refund1=false;
    bool public refund2=false;
    

    struct Choice{
        uint deposit;
        bytes32 choice;
    }

    Choice choicePlayer1;
    Choice choicePlayer2;
    
    constructor() {
        manager = payable(msg.sender);
        
    }

    function depositReward() external payable {
    require(msg.sender == manager, "Only the contract creator (manager) can deposit ether");
    // Transfer the ether to the contract balance
    reward = msg.value;
}
    function choose(bytes32 choice) external payable {
        require(msg.sender==player1 || msg.sender==player2,"Only the known Player1 OR Player2 can participate in this game");
        require(msg.value==5 ether,"Must make a deposit of 5ETH to make a choice");
        require(ended==false,"The contract has already finished.");
        if (msg.sender == player1){
            if(choicePlayer1.deposit==0){
                choicePlayer1.choice= choice;
                choicePlayer1.deposit=msg.value;
            }
            else revert("Player 1 has already made a choice and deposit");
        }
       
        if(msg.sender==player2){
            if(choicePlayer2.deposit==0){
                choicePlayer2.choice= choice;
                choicePlayer2.deposit=msg.value;
            }
            else revert("Player 2 has already made a choice and deposit");
        }

    }

    function reveal(string calldata revealedChoice,string calldata nonce) external payable{
        require(choicePlayer1.deposit==5 ether&& choicePlayer2.deposit==5 ether, "Both Players must choose before revealing!" );
        require(ended==false,"Smart Contract reveal has ended already!");
        require(msg.sender==player1 || msg.sender==player2);

        if(msg.sender==player1 && bytes(choice1).length!=0) revert("Player 1 has already revealed!");
        if(msg.sender==player2 && bytes(choice2).length!=0) revert("Player 2 has already revealed!");

        if(msg.sender==player1){
            choice1= revealedChoice;
            nonce1=nonce;
            if(choicePlayer1.choice == keccak256(abi.encodePacked(choice1,nonce1) ) )
             refund1=true;
        }
        if(msg.sender==player2){
            choice2= revealedChoice;
            nonce2=nonce;
            if(choicePlayer2.choice == keccak256(abi.encodePacked(choice2,nonce2) ) ) 
                refund2=true;
        }
        // this code will be executed only when both players have entered a choice
        if(bytes(choice1).length!=0 && bytes(choice2).length!=0 ){ 
            //both players have cheated or put invalid input (not rock paper or scissors), send the reward and deposit back to the manager
            if(!refund1 && !refund2
            || !(compareStrings(choice1,"rock") || compareStrings(choice1,"scissors") || compareStrings(choice1,"paper")) && 
                !(compareStrings(choice2,"rock") || compareStrings(choice2,"scissors") || compareStrings(choice2,"paper"))){
                payable(manager).transfer(choicePlayer1.deposit);
                payable(manager).transfer(choicePlayer2.deposit);
                payable(manager).transfer(reward);
                ended=true;
                return;
            }   
            // player 1 cheated or invalid input, transfer to player 2 the reward and player1's deposit
            if(!refund1 || !(compareStrings(choice1,"rock") || compareStrings(choice1,"scissors") || compareStrings(choice1,"paper"))){
                payable(player2).transfer(choicePlayer1.deposit);
                payable(player2).transfer(choicePlayer2.deposit);
                payable(player2).transfer(reward);
            }
            // similarly if player 2 cheated
            else if (!refund2 || !(compareStrings(choice2,"rock") || compareStrings(choice2,"scissors") || compareStrings(choice2,"paper"))){
                payable(player1).transfer(choicePlayer2.deposit);
                payable(player1).transfer(choicePlayer1.deposit);
                payable(player1).transfer(reward);
            }
            else if(refund1 && refund2){
                // execute rock paper scissors game
                
                // if a draw happens, distribute the reward
                if(compareStrings(choice1,choice2)){
                    uint halfReward = reward/2;
                    payable(player1).transfer(halfReward);
                    payable(player2).transfer(halfReward);
                }
                // check when player1 is a winner
                else if ((compareStrings(choice1, "rock") && compareStrings(choice2, "scissors")) ||
                    (compareStrings(choice1, "paper") && compareStrings(choice2, "rock")) ||
                    (compareStrings(choice1, "scissors") && compareStrings(choice2, "paper"))) {
                        //player1 wins
                        payable(player1).transfer(reward);
                }
                //player2 wins
                else payable(player2).transfer(reward);
               
                // at this point, both players have executed the algorithm correctly and will get their deposits back
                if(choicePlayer1.deposit!=0) payable(player1).transfer(choicePlayer1.deposit);
                if(choicePlayer2.deposit!=0) payable(player2).transfer(choicePlayer2.deposit);
            }
            ended=true;
        }
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
         return (keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b)));
    }

    function arguments_to_keccak256(string calldata choice,string calldata nonce) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(choice,nonce) );
    }


}