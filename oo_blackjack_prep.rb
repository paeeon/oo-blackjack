# In blackjack, there is a minimum of two players - the dealer and another player. 
# (Let's assume that there is only one non-dealer player.)
# Games are always played against the dealer. 
# Every card has a value associated with it - the number cards (2-10) represent their own 
# value (the 2 card has a value of two, the 3 card has a value of three, etc.) The face cards 
# (jack, queen, and king) have a value of 10. The Ace is valued at either a 1 or 11 - meaning 
# its owner can decide which value they prefer to use. 
# The goal of the game is to get a hand that is valued at 21 or as close to 21 as possible
# without passing 21. 
# Every turn, the non-dealer player first decides whether they wish to 'hit' or 'stay'. 
# 'Hit' means receiving a card dealt from the deck, 'stay' means to keep your current hand 
# without receiving a card. 
# If the non-dealer decides to 'hit', the turn passes to the dealer. 
# The dealer will choose whether or not they wish to 'hit' or 'stay'. 
# (Typically, the house has a rule that requires dealers to 'hit' until they arrive at a 
# value of 17 or more. Afterwards, they must stay.)
# The game continues until (a) one of the players hits blackjack (gets a hand that's valued at
# exactly 21), (b) one of the players 'busts' (gets a hand over 21) or (c) the non-dealer 
# player decides to 'stay'. If one of the players hits blackjack, they are automatically 
# chosen as winner. If one of the players 'busts', the other player automatically is 
# chosen as winner. If the non-dealer player decides to stay, their hand is compared to the 
# dealer's hand. Whoever has the highest value is chosen as winner. 

Major nouns: 

Player 
- Dealer
- User

Hand
- Players have hands
- Filled with cards

Deck
- Filled with cards

Card
- Have a suit and a value 

Game (game engine)