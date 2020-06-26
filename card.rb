require_relative 'deck'

class Card < Deck
  attr_accessor :name, :suit

  CARDS_NAMES = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  CARDS_SUITS = %w[+ <3 ^ <>].freeze

  def initialize
    @name = CARDS_NAMES[rand(CARDS_NAMES.length)]
    @suit = CARDS_SUITS[rand(CARDS_SUITS.length)]
  end
end
