require './lib/blackjack/game'
require './lib/blackjack/player'

# The actual game is played here.
game = Blackjack::Game.new
deck = game.load_deck(ARGV[0])
game.print_outcome(deck)
