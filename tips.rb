module Tips
  def show_start_name_tip
    puts 'Введите имя игрока?'
    user_answer
  end

  def show_game_menu
    show_player_table
    show_dealer_table
    puts "1.Пропустить, #{'2.Добавить карту,' if player.cards.length < 3} 3.Открыть карты"
    return @answer = '3' if max_cards?

    user_answer
  end

  def show_player_table
    puts "Игрок: #{player.name}
          Ваши карты: #{player.cards}, очки: #{player.score}
          Деньги: #{player.money}"
  end

  def show_dealer_table
    puts "Игрок: Дилер
          Карты: ** ** #{'**' if dealer.cards.length == 3}"
  end

  def show_cards
    puts "Ваши карты: #{player.cards}, очки: #{player.score}
          карты Дилера: #{dealer.cards}, очки: #{dealer.score}"
  end

  def show_restart_tip
    puts 'Хотите переиграть?
          1.Да
          2.Нет'
    user_answer
  end

  def dealer_win_tip
    dealer.add_bet
    show_restart_tip
    continue_game(answer)
  end

  def player_win_tip
    player.add_bet
    show_restart_tip
    continue_game(answer)
  end
end
