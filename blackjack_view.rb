require_relative 'blackjack_controller'

class BlackJackView
  def add_player_name_tip
    puts 'Введите имя игрока'
  end

  def show_menu
    show_player_table
    show_dealer_table
    show_next_step
  end

  def show_player_card
    puts "Добавлена карта: #{player.deck.cards[2].name}#{player.deck.cards[2].suit}"
  end

  def show_all_cards
    puts "Ваши карты: #{player.deck.cards_names}, очки: #{player.score}"
    puts "Карты Дилера: #{dealer.deck.cards_names}, очки: #{dealer.score}"
  end

  def show_continue_tip
    puts 'Продолжить ? "yes" : "no"'
  end

  def show_player_table
    puts "Игрок: #{player.name}
          Карты: #{player.deck.cards_names}
          Очки: #{player.score}
          Деньги: #{player.money}"
  end

  def show_dealer_table
    puts "Игрок: Дилер
          Карты: ** ** #{'**' if dealer.deck.cards.length == 3}
          Деньги: #{dealer.money}"
  end

  def show_next_step
    puts "1.Пропустить ход#{', 2.Добавить карту,' if player.deck.cards.length < 3} 3.Открыть карты"
  end
end
