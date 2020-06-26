require_relative 'players'
require_relative 'player'
require_relative 'dealer'
require_relative 'card'
require_relative 'deck'
require_relative 'blackjack_controller'
require_relative 'blackjack_model'

class BlackJackView
  attr_accessor :game

  STEPS = { '1' => :miss_step, '2' => :add_card_step, '3' => :open_step }.freeze

  def initialize(game)
    @game = game
  end

  def start
    add_player_name_tip
    game.start_game
    menu
  end

  def menu
    open_step if game.max_cards?
    show_menu_table
    game.choose_step
    send STEPS[game.answer]
  end

  def miss_step
    game.player_miss
    menu
  rescue RuntimeError => e
    puts e.message
    game.player.take_bet
    show_continue_tip
    return unless game.continue?

    game.refresh_game
    menu
  end

  def add_card_step
    game.add_player_card
    show_player_card
    menu
  rescue RuntimeError => e
    puts e.message
    game.dealer.take_bet
    show_continue_tip
    return unless game.continue?

    game.refresh_game
    menu
  end

  def open_step
    show_all_cards
    game.open_cards
    show_continue_tip
    return unless game.continue?

    game.refresh_game
    menu
  end

  private

  def add_player_name_tip
    puts 'Введите имя игрока'
  end

  def show_menu_table
    show_player_table
    show_dealer_table
    show_next_step
  end

  def show_player_card
    puts "Добавлена карта: #{game.player_cards[2].name}"
  end

  def show_all_cards
    puts "Ваши карты: #{game.player_cards_names}, очки: #{game.player_score}"
    puts "Карты Дилера: #{game.dealer_cards_names}, очки: #{game.dealer_score}"
  end

  def show_continue_tip
    puts 'Продолжить ? "yes" : "no"'
  end

  def show_player_table
    puts "Игрок: #{game.player.name}
          Карты: #{game.player_cards_names}
          Очки: #{game.player_score}
          Деньги: #{game.player.money}"
  end

  def show_dealer_table
    puts "Игрок: Дилер
          Карты: ** ** #{'**' if game.dealer_cards.length == 3}
          Деньги: #{game.dealer.money}"
  end

  def show_next_step
    puts "1.Пропустить ход#{', 2.Добавить карту,' if game.player_cards.length < 3} 3.Открыть карты"
  end
end
