require_relative 'players'
require_relative 'player'
require_relative 'dealer'
require_relative 'card'
require_relative 'deck'
require_relative 'blackjack_controller'

class BlackJackView
  attr_accessor :game, :answer

  STEPS = { '1' => :miss_step, '2' => :add_card_step, '3' => :open_step }.freeze

  def initialize
    add_player_name_tip
    @game = BlackJackController.new(user_answer)
  end

  def start
    game.start_game
    menu
  end

  def menu
    open_step if game.max_cards?
    show_menu_table
    user_answer
    send STEPS[answer]
  end

  def miss_step
    game.player_miss
    menu
  rescue RuntimeError => e
    puts e.message
    game.player.take_bet
    show_continue_tip
    user_answer
    return unless game.continue?(answer)

    game.refresh_game
    menu
  end

  def add_card_step
    game.give_card(game.player)
    show_player_card
    menu
  rescue RuntimeError => e
    puts e.message
    game.dealer.take_bet
    show_continue_tip
    user_answer
    return unless game.continue?(answer)

    game.refresh_game
    menu
  end

  def open_step
    show_all_cards
    game.open_cards
    show_continue_tip
    user_answer
    return unless game.continue?(answer)

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
    puts "Добавлена карта: #{game.player.cards[2].name}"
  end

  def show_all_cards
    puts 'Ваши карты:'
    show_player_cards
    puts "очки: #{game.player.score}"
    puts 'Карты Дилера:'
    show_dealer_cards
    puts "очки: #{game.dealer.score}"
  end

  def show_continue_tip
    puts 'Продолжить ? "yes" : "no"'
  end

  def show_player_table
    puts "Игрок: #{game.player.name}
Очки: #{game.player.score}
Деньги: #{game.player.money}
Карты:"
    show_player_cards
  end

  def show_dealer_table
    puts "Игрок: Дилер
Карты: ** ** #{'**' if game.dealer.cards.length == 3}
Деньги: #{game.dealer.money}"
  end

  def show_next_step
    puts "1.Пропустить ход#{', 2.Добавить карту,' if game.player.cards.length < 3} 3.Открыть карты"
  end

  def show_player_cards
    game.player.cards.each do |card|
      puts card.name
    end
  end

  def show_dealer_cards
    game.dealer.cards.each do |card|
      puts card.name
    end
  end

  def user_answer
    self.answer = gets.chomp
  end
end
