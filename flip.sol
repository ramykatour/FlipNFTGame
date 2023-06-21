pragma solidity ^0.8.0;

contract FlipNFTGame {
    address public owner;
    uint256 public joinGamePrice = 0.001 ether;
    uint256 public commissionRate = 10; // 10% commission for the owner
    uint256 public numPlayers;
    address public winner;
    bool public gameEnded;
    mapping(address => uint256) public playerBalances;

    event GameJoined(address indexed player, uint256 amount);
    event GameEnded(address indexed winner, uint256 amountWon);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    modifier gameNotEnded() {
        require(!gameEnded, "The game has already ended.");
        _;
    }

    function joinGame() external payable gameNotEnded {
        require(msg.value == joinGamePrice, "Invalid amount sent.");

        playerBalances[msg.sender] += msg.value;
        numPlayers++;

        emit GameJoined(msg.sender, msg.value);
    }

    function flipCoin() external gameNotEnded {
        require(numPlayers >= 2, "Minimum two players required to play the game.");
        require(playerBalances[msg.sender] > 0, "You need to join the game first.");

        // Implement your logic for the coin flip game here.
        // This is just a sample implementation, you can modify it as per your requirements.
        uint256 randomResult = block.timestamp % numPlayers;
        address[] memory players = new address[](numPlayers);

        uint256 index = 0;
        for (uint256 i = 0; i < numPlayers; i++) {
            address playerAddress = address(uint160(uint256(keccak256(abi.encodePacked(msg.sender, i)))));
            if (playerBalances[playerAddress] > 0) {
                players[index] = playerAddress;
                index++;
            }
        }

        winner = players[randomResult];
        uint256 commission = (joinGamePrice * numPlayers * commissionRate) / 100;
        uint256 amountWon = (joinGamePrice * numPlayers) - commission;

        playerBalances[winner] += amountWon;

        gameEnded = true;

        emit GameEnded(winner, amountWon);
    }

    function withdrawWinnings() external {
        require(gameEnded, "The game has not ended yet.");
        require(playerBalances[msg.sender] > 0, "You have no winnings to withdraw.");

        uint256 amount = playerBalances[msg.sender];
        playerBalances[msg.sender] = 0;

        payable(msg.sender).transfer(amount);
    }

    function withdrawCommission() external onlyOwner {
        require(gameEnded, "The game has not ended yet.");
        require(address(this).balance > 0, "No commission available to withdraw.");

        uint256 commissionAmount = (joinGamePrice * numPlayers * commissionRate) / 100;
        payable(owner).transfer(commissionAmount);
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
