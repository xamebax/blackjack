# Blackjack

This is an implementation of a Blackjack game for recruitment purposes, with rules according to an offline specification.

## Requirements

Tested and developed with Ruby 2.5.1. Apart from Ruby, you should have at least Bundler installed:

```bash
$ gem install bundler
```

Assuming you have Ruby and Bundler installed, in the directory of the project, run:

```bash
$ bundle install
```

to install all dependent gems.

## Usage

You can execute a Blackjack game in two ways: with or without a predefined set of cards. To watch a game with a ready set of cards, execute the following command, assuming the cards are in a file called `cards.txt`:

```bash
$ ruby blackjack.rb cards.txt
```

You can omit the name of the file containing the shuffled deck. If you do, the program will generate a deck.

## Testing

**Linting** is done via Rubocop. To run the linter, execute `bundle exec rubocop .` in the project directory (make sure you ran `bundle install` first).

**Unit tests** are in `blackjack_spec.rb`. To run them, execute the following command in the project's directory: `rspec blackjack_spec.rb`.
