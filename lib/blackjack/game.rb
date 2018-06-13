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
    # TODO: if a file doesn't exist, an error should be raised.
    def load_deck(path = nil)
      if path.nil? || !File.file?(path)
        generate_deck
      else
        deck = File.read(path).split(', ')
        deck.last.strip!
        deck
      end
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

    # sam_plays takes an array. We don't care about its return value.
    # TODO: Move instantiating sam and dealer into separate steps, so we can
    # merge these into one method.
    def sam_plays(deck)
      card = draw_card(deck)
      @sam ||= Blackjack::Player.new('sam')
      @sam.cards << card
      @sam.score += card_value(card)
    end

    # dealer_plays takes an array. We don't care about its return value.
    def dealer_plays(deck)
      card = draw_card(deck)
      @dealer ||= Blackjack::Player.new('dealer')
      @dealer.cards << card
      @dealer.score += card_value(card)
    end

    # TODO: If there are no cards left, an error should be raised.
    # draw_card takes an array and returns its first element, removing it
    # from the array.
    def draw_card(deck)
      deck.shift
    end

    # first_round takes an Array object. We don't care about its return value.
    def first_round(deck)
      sam_plays(deck)
      dealer_plays(deck)
      sam_plays(deck)
      dealer_plays(deck)
    end

    # early_winner determins a winner after the first round of cards.
    def early_winner
      case @sam.score
      when 21 # Sam wins regardless if the dealer has 21.
        return @sam.name
      when 22 # dealer wins regardless if he has 22.
        return @dealer.name
      end
      case @dealer.score
      when 21
        return @dealer.name
      end
    end

    # play takes a deck of cards (an Array object) and returns a string with
    # the name of the winner.
    def play(deck)
      first_round(deck)
      return early_winner unless early_winner.nil?
      loop do
        return @sam.name if @sam.score == 21
        return @dealer.name if @sam.score > 21
        break if @sam.score >= 17
        sam_plays(deck)
      end
      loop do
        return @sam.name if @dealer.score > 21
        break if @dealer.score > @sam.score
        return @dealer.name if @dealer.score == 21
        dealer_plays(deck)
      end
      determine_winner
    end

    # I assumed that the dealer wins on a tie
    def determine_winner
      if 21 - @sam.score >= 21 - @dealer.score
        @dealer.name
      else
        @sam.name
      end
    end

    # TODO: play should be called separately and its returned value stored
    # in a variable that's later referenced here
    def print_outcome(deck)
      puts play(deck).to_s
      puts "sam: #{@sam.cards.join(', ')}"
      puts "dealer: #{@dealer.cards.join(', ')}"
    end
  end
end
