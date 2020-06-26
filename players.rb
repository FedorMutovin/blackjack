class Players
  attr_accessor :money, :score, :deck

  def initialize
    @money = 100
    @deck = Deck.new
  end

  def take_bet
    self.money += 20
  end

  def return_bet
    self.money += 10
  end

  def add_bet
    self.money -= 10
  end

  def calculate_score
    @score = 0
    deck.cards.each do |card|
      add_score(10) if %w[J K Q].include?(card.name)
      if card.name != 'A'
        add_score(card.name.to_i)
      else
        add_ace
      end
    end
    calculate_ace
  end

  private

  def add_score(value)
    @score += value
  end

  def add_ace
    @ace ||= 0
    @ace += 1
  end

  def calculate_ace
    return if @ace.nil? || @ace.zero?

    (score + 11) <= 21 ? add_score(11) : add_score(1)
    @ace = 0
  end
end
