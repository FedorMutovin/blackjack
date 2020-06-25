class Players
  attr_accessor :money, :cards, :score

  CARDS_TYPES = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  CARDS_SUITS = %w[+ <3 ^ <>].freeze

  def initialize
    @money = 100
    @cards = []
    @score = 0
    give_start_cards
    take_bet
  end

  def take_card
    add_card
  end

  def restart_cards
    self.score = 0
    give_start_cards
    take_bet
  end

  def add_bet
    self.money += 20
  end

  def return_bet
    self.money += 10
  end

  private

  def take_bet
    self.money -= 10
  end

  def give_start_cards
    2.times { add_card }
  end

  def add_card
    card_type = CARDS_TYPES[rand(CARDS_TYPES.length)]
    card_suit = CARDS_SUITS[rand(CARDS_SUITS.length)]
    card = "#{card_type}#{card_suit}"
    cards << card
    calculate_score(card_type)
  end

  def calculate_score(card_type)
    if card_type == 'A'
      (score + 11) > 21 ? add_score(1) : add_score(11)
    elsif %w[J K Q].include?(card_type)
      add_score(10)
    else
      add_score(card_type.to_i)
    end
  end

  def add_score(value)
    self.score += value
  end
end