require_relative 'players'
require_relative 'player'
require_relative 'dealer'
require_relative 'tips'

class BlackJack
  include Tips
  attr_accessor :answer, :player, :dealer

  STEPS = { '1' => :miss, '2' => :give_card, '3' => :open_cards }.freeze

  def initialize
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    start_name_tip
    player.name = answer
    puts "Игрок: #{player.name}
          Ваши карты: #{player.cards}, очки: #{player.score}
          Деньги: #{player.money}
          Игрок: Дилер
          Карты: ** **
          1.Пропустить, 2.Добавить карту, 3.Открыть карты"
    user_answer
    send STEPS[answer]
  end

  def give_card
    player.take_card
    puts "Игрок: #{player.name}
          Ваши карты: #{player.cards}, очки: #{player.score}
          Деньги: #{player.money}
          Игрок: Дилер
          Карты: ** **
          1.Пропустить, 2.Добавить карту, 3.Открыть карты"
    user_answer
    send STEPS[answer]
  end

  private

  def user_answer
    self.answer = gets.chomp
  end
end
