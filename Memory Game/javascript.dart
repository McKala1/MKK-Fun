const cards = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
let flippedCards = [];
let pairsMatched = 0;
let hasFlippedCard = false;
let lockBoard = false;

const gameBoard = document.getElementById('gameBoard');

function shuffleCards() {
    for (let i = cards.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [cards[i], cards[j]] = [cards[j], cards[i]];
    }
}

function createCard(cardContent, index) {
    const card = document.createElement('div');
    card.classList.add('card');
    card.dataset.index = index;
    card.innerHTML = `<img src="https://via.placeholder.com/100?text=${cardContent}" alt="${cardContent}">`;
    card.addEventListener('click', flipCard);
    gameBoard.appendChild(card);
}

function flipCard() {
    if (lockBoard || this === flippedCards[0]) return;
    this.classList.add('flipped');

    if (!hasFlippedCard) {
        hasFlippedCard = true;
        flippedCards[0] = this;
        return;
    }

    flippedCards[1] = this;
    checkForMatch();
}

function checkForMatch() {
    const isMatch = flippedCards[0].dataset.index === flippedCards[1].dataset.index;
    isMatch ? disableCards() : unflipCards();
}

function disableCards() {
    flippedCards.forEach(card => {
        card.removeEventListener('click', flipCard);
        pairsMatched++;
    });

    if (pairsMatched === cards.length / 2) {
        setTimeout(() => {
            alert('Congratulations! You won!');
        }, 500);
    }

    resetBoard();
}

function unflipCards() {
    lockBoard = true;
    setTimeout(() => {
        flippedCards.forEach(card => card.classList.remove('flipped'));
        resetBoard();
    }, 1000);
}

function resetBoard() {
    [hasFlippedCard, lockBoard] = [false, false];
    flippedCards.length = 0;
}

function restartGame() {
    gameBoard.innerHTML = '';
    pairsMatched = 0;
    resetBoard();
    shuffleCards();
    cards.forEach((cardContent, index) => createCard(cardContent, index));
}

document.getElementById('restart-btn').addEventListener('click', restartGame);

// Initialize the game
shuffleCards();
cards.forEach((cardContent, index) => createCard(cardContent, index));
