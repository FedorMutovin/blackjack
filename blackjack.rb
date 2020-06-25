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

  def player_miss
    dealer.score >= 17 ? dealer_miss : add_dealer_card
  end

  def add_player_card
    player.take_card
    raise "Вы проиграли, Ваши очки больше 21(#{player.score})" if player.score > 21

    player_miss
  rescue RuntimeError => e
    puts e.message
    dealer_win_tip
  end

  def dealer_miss
    select_step
  end

  def add_dealer_card
    dealer.take_card if dealer.cards.length < 3
    raise "Дилер проиграл, очки Дилера больше 21(#{dealer.score})" if dealer.score > 21

    select_step
  rescue RuntimeError => e
    puts e.message
    player_win_tip
  end

  def open_cards
    show_cards
    draw_result
    dealer_win_result
    player_win_result
  rescue RuntimeError => e
    puts e.message
    show_restart_tip
    continue_game(answer)
  end

  def max_cards?
    !!(player.cards.length == 3 && dealer.cards.length == 3)
  end

  private

  def continue_game(answer)
    return unless answer == '1'

    restart_player
    restart_dealer
    select_step
  end

  def restart_player
    player.cards = []
    player.restart_cards
    raise 'У вас закончились монеты, вы проиграли' if player_lose?
  end

  def restart_dealer
    dealer.cards = []
    dealer.restart_cards
    raise 'У дилера закончились монеты, вы выиграли' if dealer_lose?
  end

  def select_step
    show_game_menu
    send PLAYER_STEPS[answer]
  end

  def user_answer
    self.answer = gets.chomp
  end

  def dealer_lose?
    dealer.money.negative? || dealer.money.zero?
  end

  def player_lose?
    player.money.negative? || player.money.zero?
  end

  def draw_result
    return unless draw?

    dealer.return_bet
    player.return_bet
    raise 'Ничья'
  end

  def dealer_win_result
    return unless dealer_win?

    dealer.add_bet
    raise 'Вы проиграли'
  end

  def player_win_result
    player.add_bet
    raise 'Дилер проиграл'
  end

  def dealer_win?
    21 - player.score > 21 - dealer.score
  end

  def draw?
    21 - player.score == 21 - dealer.score
  end
end
