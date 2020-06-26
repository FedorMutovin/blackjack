class Players
  attr_accessor :money

  def initialize
    @money = 100
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

  private

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
