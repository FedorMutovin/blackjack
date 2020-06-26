require_relative 'players'
require_relative 'player'
require_relative 'dealer'
require_relative 'card'
require_relative 'deck'
require_relative 'blackjack_view'

class BlackJackController < BlackJackView
  attr_accessor :answer, :player, :dealer

  PLAYER_STEPS = { '1' => :player_miss, '2' => :add_player_card, '3' => :open_cards }.freeze
  DEALER_STEPS = { '1' => :dealer_miss, '2' => :add_dealer_card }.freeze

  def initialize
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    add_player_name_tip
    player.name = user_answer
    give_start_cards
    take_start_bets
    dealer.calculate_score
    player.calculate_score
    choose_step
  end

  def choose_step
    open_cards if max_cards?

    show_menu
    user_answer
    send PLAYER_STEPS[answer]
  end

  def player_miss
    dealer_miss if dealer.score > 17 || dealer.deck.cards.length == 3

    add_dealer_card
  end

  def dealer_miss
    choose_step
  end

  def add_dealer_card
    dealer.deck.add_card

    dealer.calculate_score
    raise "Превышено кол-во очков, Дилер проиграл(#{dealer.score},#{dealer.deck.cards_names})" unless dealer.score <= 21

    dealer_miss
  rescue RuntimeError => e
    puts e.message
    player.take_bet
    show_continue_tip
    refresh_game if continue?
  end

  def add_player_card
    player.deck.add_card
    show_player_card
    player.calculate_score
    raise "Превышено кол-во очков, Вы проиграли(#{player.score}, #{player.deck.cards_names})" unless player.score <= 21

    player_miss
  rescue RuntimeError => e
    puts e.message
    dealer.take_bet
    show_continue_tip
    refresh_game if continue?
  end

  def open_cards
    show_all_cards
    draw_result
    dealer_win? ? dealer_win_result : player_win_result
  rescue RuntimeError => e
    puts e.message
    show_continue_tip
    refresh_game if continue?
  end

  private

  def continue?
    user_answer
    return true if answer == 'yes'

    false
  end

  def draw_result
    return unless draw?

    return_start_bets
    raise 'Ничья'
  end

  def refresh_game
    refresh_all_cards
    take_start_bets
    dealer.calculate_score
    player.calculate_score
    choose_step
  end

  def draw?
    dealer.score == player.score
  end

  def player_win_result
    player.take_bet
    raise 'Вы выиграли'
  end

  def dealer_win_result
    dealer.take_bet
    raise 'Дилер выиграл'
  end

  def dealer_win?
    21 - dealer.score <= 21 - player.score
  end

  def max_cards?
    dealer.deck.cards.length == 3 && player.deck.cards.length == 3
  end

  def refresh_all_cards
    player.deck.refresh_cards
    dealer.deck.refresh_cards
  end

  def give_start_cards
    player.deck.add_start_cards
    dealer.deck.add_start_cards
  end

  def take_start_bets
    player.add_bet
    dealer.add_bet
  end

  def return_start_bets
    player.return_bet
    dealer.return_bet
  end

  def user_answer
    self.answer = gets.chomp
  end
end
