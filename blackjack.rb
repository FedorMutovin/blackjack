require_relative 'players'
require_relative 'player'
require_relative 'dealer'
require_relative 'tips'

class BlackJack
  include Tips
  attr_accessor :answer, :player, :dealer

  PLAYER_STEPS = { '1' => :player_miss, '2' => :add_player_card, '3' => :open_cards }.freeze
  DEALER_STEPS = { '1' => :dealer_miss, '2' => :add_dealer_card }.freeze

  def initialize
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    show_start_name_tip
    player.name = answer
    select_step
  end

  def add_player_card
    player.take_card
    raise 'Вы проиграли' if player.score > 21

    select_step

  rescue RuntimeError => e
    puts e.message
    dealer.money += 10
    player.money -= 10
    show_restart_tip
    continue_game(answer)
  end

  def player_miss
    dealer.score >= 17 ? dealer_miss : add_dealer_card
  end

  def continue_game(answer)
    return unless answer == '1'

    player.cards = []
    dealer.cards = []
    player.restart_cards
    dealer.restart_cards
    select_step
  end

  def dealer_miss
    select_step
  end

  def add_dealer_card
    dealer.take_card
    raise 'Дилер проиграли' if dealer.score > 21

    select_step

  rescue RuntimeError => e
    puts e.message
    dealer.money -= 10
    player.money += 10
    show_restart_tip
    continue_game(answer)
  end

  def open_cards
    if 21 - player.score > 21 - dealer.score
      dealer.money += 10
      player.money -= 10
      raise 'Вы проиграли'
    else
      dealer.money -= 10
      player.money += 10
      raise 'Дилер проиграл'
    end
  rescue RuntimeError => e
    puts e.message
    show_restart_tip
    continue_game(answer)
  end

  def max_cards?
    !!(player.cards.length == 3 && dealer.cards.length == 3)
  end

  private

  def select_step
    show_game_menu
    send PLAYER_STEPS[answer]
  end

  def user_answer
    self.answer = gets.chomp
  end
end
