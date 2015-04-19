require 'colorize'
require 'pry'

class Player
  attr_reader :hand
  attr_accessor :status

  def initialize
    @hand = Hand.new
    @status = "Hitting"
  end

  def blackjack?
    true if (hand.hand_value[0] == 21) || (hand.hand_value[1] == 21)
  end

  def bust?
    true if (hand.hand_value[0] > 21)
  end

  def display_hand_value  # Is there a better name for this? 
    if hand.hand_value[0] == hand.hand_value[1]
      puts "#{self} hand is valued at #{hand.hand_value[0]}."
    else
      puts "#{self} hand is valued at either #{hand.hand_value[0]} or #{hand.hand_value[1]}."
    end
  end
end

class Dealer < Player
  def makes_a_move(deck)
    if status == "Hitting"
      puts "Dealer is making their move…"
      sleep(1)
      if hand.hand_value[1] < 17
        puts "Dealer chose to hit.".light_blue
        deck.deal(self)
      elsif hand.hand_value[1] >= 17
        puts "Dealer chose to stay.".light_blue
        self.status = "Staying"
      end
    else
      puts "Dealer chose to stay.".light_blue
    end
    sleep(1)
  end

  def to_s
    "Dealer's"
  end
end

class User < Player
  def makes_a_move(deck)
    if status == "Hitting"
      puts "What would you like to do? Type 'h' for hit and 's' for stay.".yellow
      move_choice = gets.chomp
      if move_choice == 'h'
        puts "You chose to hit.".light_blue
        deck.deal(self)
      elsif move_choice == 's'
        puts "You chose to stay.".light_blue
        self.status = "Staying"
      end
    else
      puts "You chose to stay.".light_blue
    end
  end

  def to_s
    "Your"
  end
end

class Hand
  attr_reader :cards_in_hand
  attr_accessor :num_cards_in_hand, :hand_value

  @@card_values = {'J'=>10, 'Q'=>10, 'K'=>10}
  (2..10).each do |num|
    @@card_values[num.to_s] = num
  end

  def initialize
    @cards_in_hand = []
    @hand_value = [0, 0]
    @num_cards_in_hand = 0
  end

  def add_to_hand_value(card)
    if card.value == 'A'
      hand_value[0] += 1
      hand_value[1] += 11
    else
      hand_value[0] += @@card_values[card.value]
      hand_value[1] += @@card_values[card.value]
    end
  end
end

class Deck
  attr_accessor :cards_in_deck

  def initialize
    @cards_in_deck = []
    ['Diamonds','Clubs','Hearts','Spades'].each do |suit|
      ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'].each do |value|
        @cards_in_deck << Card.new(suit, value)
      end
    end
    scramble_cards!
  end

  def scramble_cards!
    cards_in_deck.shuffle!
  end

  def deal(player, num_times_to_deal=1)
    num_times_to_deal.times do
      card_to_deal = cards_in_deck.sample
      player.hand.cards_in_hand << card_to_deal
      cards_in_deck.delete(card_to_deal)
      player.hand.num_cards_in_hand += 1
      player.hand.add_to_hand_value(card_to_deal)
    end
  end
end

class Card
  attr_reader :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    "#{value} of #{suit}"
  end
end

class Game
  attr_reader :deck, :dealer, :user

  def initialize
    @deck = Deck.new
    @dealer = Dealer.new
    @user = User.new
  end

  def display_cards(reveal=false)
    puts "*** Dealer's Cards ***".yellow
    puts dealer.hand.cards_in_hand.first
    if !reveal
      puts "…And #{dealer.hand.num_cards_in_hand - 1} other card.\n" if dealer.hand.num_cards_in_hand == 2
      puts "…And #{dealer.hand.num_cards_in_hand - 1} other cards.\n" if dealer.hand.num_cards_in_hand > 2
    else
      dealer.hand.cards_in_hand.each do |card|
        puts card
      end
      dealer.display_hand_value
    end
    puts
    puts "*** Your Cards ***".yellow
    user.hand.cards_in_hand.each do |card|
      puts card
    end
    user.display_hand_value
  end

  def compare_hands
    if best_hand_value(user) > best_hand_value(dealer)
      puts "You have the higher hand value! You win!".green
    elsif best_hand_value(dealer) > best_hand_value(user)
      puts "The dealer has the higher hand value! You lose!".red
    else
      puts "It's a tie!".green
    end
  end

  def best_hand_value(player)
    if player.hand.hand_value[1] > 21
      player.hand.hand_value[0]
    else
      player.hand.hand_value[1]
    end
  end

  def everyones_staying?
    true if (user.status == "Staying") && (dealer.status == "Staying")
  end

  def endgame_conditions?
    true if user.blackjack? || user.bust? || dealer.blackjack? || dealer.bust? || everyones_staying?
  end

  def play
    deck.deal(dealer, 2)
    deck.deal(user, 2)
    loop do
      system 'clear'
      break if endgame_conditions?
      display_cards
      user.makes_a_move(deck)
      sleep(1)
      break if endgame_conditions?
      dealer.makes_a_move(deck)
    end
    system 'clear'
    display_cards(true)
    if everyones_staying?
      compare_hands
    else
      if user.blackjack?
        puts "Blackjack! You win!".green
      elsif user.bust?
        puts "Oh nooo :( Looks like you busted… You lose!".red
      elsif dealer.blackjack?
        puts "The dealer hit blackjack! You lose!".red
      elsif dealer.bust?
        puts "The dealer busted! You win!".green
      end
    end
    puts "Wanna play again? (y/n)".green
    play_again = gets.chomp.downcase
    Game.new.play if play_again == 'y'
  end
end

Game.new.play