require_relative 'players'

class Deck
  attr_accessor :cards, :cards_names

  def initialize
    @cards = []
    @cards_names = []
  end

  def add_start_cards
    2.times { add_card }
  end

  def refresh_cards
    self.cards = []
    self.cards_names = []
    add_start_cards
  end

  def add_card
    card = Card.new
    cards << card
    cards_names << "#{card.name}#{card.suit}"
  end
end
