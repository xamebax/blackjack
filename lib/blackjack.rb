require './lib/blackjack/game'
require './lib/blackjack/player'

# The actual game is played here.
game = Blackjack::Game.new
@sam = Blackjack::Player.new('sam')
@dealer = Blackjack::Player.new('dealer')
@deck = game.load_deck(ARGV[0])
game.print_outcome(@sam, @dealer, @deck)
