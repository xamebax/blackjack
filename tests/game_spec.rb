# Insert the `lib/` subdirectory in front of the require path
lib = File.join(File.dirname(__FILE__), 'lib')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'blackjack/game'

RSpec.describe Blackjack::Game do
  describe '#generate_deck' do
    it 'generates a deck of 52 cards' do
      game = Blackjack::Game.new
      deck = game.generate_deck
      expect(deck.length).to eq(52)
    end
  end

  describe '#load_deck' do
    it 'loads a file with a deck of cards' do
      game = Blackjack::Game.new
      deck = game.load_deck('test_deck')
      expect(deck).to_not be_nil
      expect(deck.length).to eq(52)
    end
    it 'generates a deck if file is empty' do
      game = Blackjack::Game.new
      deck = game.load_deck
      expect(deck).to_not be_nil
      expect(deck.length).to eq(52)
    end
  end

  describe '#card_value' do
    it 'calculates the value of a card' do
      game = Blackjack::Game.new
      expect(game.card_value('HQ')).to eq(10)
      expect(game.card_value('C10')).to eq(10)
      expect(game.card_value('S3')).to eq(3)
      expect(game.card_value('DA')).to eq(11)
    end
  end

  describe '#draw_card' do
    it 'draws a card from the top of the deck and removes it' do
      game = Blackjack::Game.new
      deck = %w[DQ S3 SA C3]
      expect(game.draw_card(deck)).to eq('DQ')
      expect(deck).to eq(%w[S3 SA C3])
    end
  end

  describe '#play' do
    it "lets dealer win if it's d21:s19 in the first round" do
      deck = %w[CA DA S8 DK C7 S3]
      game = Blackjack::Game.new
      expect(game.play(deck)).to eq('dealer')
    end
    it "lets dealer win if it's d22:s22 in the first round" do
      deck = %w[DA HA CA SA]
      game = Blackjack::Game.new
      expect(game.play(deck)).to eq('dealer')
    end
    it "lets dealer win if it's d20:s19" do
      deck = %w[H9 H5 C5 SA S4 S5]
      game = Blackjack::Game.new
      expect(game.play(deck)).to eq('dealer')
    end
    it "lets sam win if it's d7:s21 in the first round" do
      deck = %w[D10 D4 HA S3 C7 S4]
      game = Blackjack::Game.new
      expect(game.play(deck)).to eq('sam')
    end
    it "lets sam win if it's d21:s21 in the first round" do
      deck = %w[DA HA CK SK S5 D3]
      game = Blackjack::Game.new
      expect(game.play(deck)).to eq('sam')
    end
    it "lets sam win if it's d22:s20" do
      deck = %w[H5 H9 SA C5 S4 S8]
      game = Blackjack::Game.new
      expect(game.play(deck)).to eq('sam')
    end
  end
end
