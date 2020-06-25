require_relative 'players'
require_relative 'player'
require_relative 'dealer'
require_relative 'tips'

class BlackJack
  include Tips
  attr_accessor :answer, :player, :dealer

  USER_STEPS = { '1' => :miss, '2' => :give_card, '3' => :open_cards }.freeze

  def initialize
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    show_start_name_tip
    player.name = answer
    select_step
  end

  def give_card
    player.take_card
    raise 'Вы проиграли' if player.score > 21

    select_step

  rescue RuntimeError
    dealer.money += 10
    player.money -= 10
    show_restart_tip
    continue_game(answer)
  end

  def miss
  end

  def continue_game(answer)
    return unless answer == '1'

    player.cards = []
    dealer.cards = []
    player.restart_cards
    dealer.restart_cards
    select_step
  end

  private

  def select_step
    show_game_menu
    send USER_STEPS[answer]
  end

  def user_answer
    self.answer = gets.chomp
  end
end
