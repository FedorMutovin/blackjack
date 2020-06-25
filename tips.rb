module Tips
  def show_start_name_tip
    puts 'Введите имя игрока?'
    user_answer
  end

  def show_game_menu
    puts "Игрок: #{player.name}
          Ваши карты: #{player.cards}, очки: #{player.score}
          Деньги: #{player.money}
          Игрок: Дилер
          Карты: ** **
          1.Пропустить, 2.Добавить карту, 3.Открыть карты"
    return @answer = '3' if max_cards?

    user_answer
  end

  def show_restart_tip
    puts 'Хотите переиграть?
          1.Да
          2.Нет'
    user_answer
  end
end
