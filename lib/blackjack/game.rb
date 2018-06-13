require './lib/blackjack/player'

# Blackjack separates the game into two classes: Game and Player.
module Blackjack
  # Game contains all the game and card logic.
  class Game
    DECK = { suits: %w[C S D H],
             cards: [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A'] }.freeze

    SPECIAL_VALUES = { 'A' => 11,
                       'J' => 10,
                       'Q' => 10,
                       'K' => 10 }.freeze

    # generate_deck returns an Array of strings with 52 elements.
    def generate_deck
      @deck = []
      DECK[:suits].each do |suit|
        DECK[:cards].each do |card|
          @deck << "#{suit}#{card}"
        end
      end
      # shuffle! is a built-in Ruby method
      @deck.shuffle!
    end

    # load_deck takes an optional path to file and returns an Array of strings.
    def load_deck(path = nil)
      return generate_deck if path.nil?
      raise "the card file doesn't exist" unless File.file?(path)
      deck = File.read(path).split(', ')
      deck.last.strip!
      deck
    end

    # card_value takes a string and returns an integer
    def card_value(card)
      value = card[1..2]
      if SPECIAL_VALUES[value].nil?
        value.to_i
      else
        SPECIAL_VALUES[value]
      end
    end

    # player_plays takes a Blackjack::Player object and an array. We don't care
    # about its return value.
    def player_plays(player, deck)
      card = draw_card(deck)
      raise 'there are no cards left' if card.nil?
      player.cards << card
      player.score += card_value(card)
    end

    # draw_card takes an array and returns its first element, removing it
    # from the array.
    def draw_card(deck)
      deck.shift
    end

    # first_round takes an Array object. We don't care about its return value.
    def first_round(sam, dealer, deck)
      player_plays(sam, deck)
      player_plays(dealer, deck)
      player_plays(sam, deck)
      player_plays(dealer, deck)
    end

    # early_winner determines a winner after the first round of cards.
    def early_winner(sam, dealer)
      case sam.score
      when 21 # Sam wins regardless if the dealer has 21.
        return sam.name
      when 22 # dealer wins regardless if he has 22.
        return dealer.name
      end
      case dealer.score
      when 21
        return dealer.name
      end
    end

    # play takes a deck of cards (an Array object) and returns a string with
    # the name of the winner.
    def play(sam, dealer, deck)
      first_round(sam, dealer, deck)
      return early_winner(sam, dealer) unless early_winner(sam, dealer).nil?
      loop do
        return sam.name if sam.score == 21
        return dealer.name if sam.score > 21
        break if sam.score >= 17
        player_plays(sam, deck)
      end
      loop do
        return sam.name if dealer.score > 21
        break if dealer.score > sam.score
        return dealer.name if dealer.score == 21
        player_plays(dealer, deck)
      end
      determine_winner(sam, dealer)
    end

    # determine_winner takes two Blackjack::Player objects and returns a string
    def determine_winner(sam, dealer)
      # I assumed that the dealer wins on a tie
      if 21 - sam.score >= 21 - dealer.score
        dealer.name
      else
        sam.name
      end
    end

    # TODO: play should be called separately and its returned value stored
    # in a variable that's later referenced here
    def print_outcome(sam, dealer, deck)
      puts play(sam, dealer, deck).to_s
      puts "sam: #{sam.cards.join(', ')}"
      puts "dealer: #{dealer.cards.join(', ')}"
    end
  end
end
