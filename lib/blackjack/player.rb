# Blackjack separates the game into two classes: Game and Player.
module Blackjack
  # Player class enables creating new players and storing data on them
  class Player
    attr_accessor :name, :cards, :score

    def initialize(name)
      @name = name
      @cards = []
      @score = 0
    end
  end
end
