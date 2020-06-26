require_relative 'deck'

class Card < Deck
  attr_accessor :name, :score

  def initialize(name, score)
    @name = name
    @score = score
  end
end
