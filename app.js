// Specify the contract address and ABI
const contractAddress = 'CONTRACT_ADDRESS';
const contractABI = [];

// Initialize Web3
let web3;
let contract;

async function init() {
    if (window.ethereum) {
        web3 = new Web3(window.ethereum);
        await window.ethereum.enable();
        contract = new web3.eth.Contract(contractABI, contractAddress);
        console.log('Web3 initialized.');
    } else {
        console.log('Web3 not available.');
    }
}

// Connect Wallet
async function connectWallet() {
    if (!web3) {
        console.log('Web3 not initialized.');
        return;
    }

    const accounts = await web3.eth.requestAccounts();
    const selectedAccount = accounts[0];
    console.log('Connected to wallet:', selectedAccount);
}

// Join Game
async function joinGame() {
    if (!web3 || !contract) {
        console.log('Web3 or contract not initialized.');
        return;
    }

    const joinGamePrice = await contract.methods.joinGamePrice().call();
    const tx = await contract.methods.joinGame().send({ value: joinGamePrice });
    console.log('Joined the game:', tx);
}

// Play Game
async function playGame() {
    if (!web3 || !contract) {
        console.log('Web3 or contract not initialized.');
        return;
    }

    const tx = await contract.methods.flipCoin().send();
    console.log('Played the game:', tx);
}

// Withdraw Winnings Ramymouner@hotmail.com
async function withdrawWinnings() {
    if (!web3 || !contract) {
        console.log('Web3 or contract not initialized.');
        return;
    }

    const tx = await contract.methods.withdrawWinnings().send();
    console.log('Withdrawn winnings:', tx);
}

// Update UI with contract and player balances
async function updateBalances() {
    if (!web3 || !contract) {
        console.log('Web3 or contract not initialized.');
        return;
    }

    const contractBalance = await web3.eth.getBalance(contractAddress);
    const playerBalance = await web3.eth.getBalance(web3.eth.defaultAccount);
    const winnerAddress = await contract.methods.winner().call();

    document.getElementById('contractBalance').innerText = web3.utils.fromWei(contractBalance);
    document.getElementById('playerBalance').innerText = web3.utils.fromWei(playerBalance);
    document.getElementById('winnerAddress').innerText = winnerAddress;
}

// Initialize app
init().then(() => {
    updateBalances();
});
