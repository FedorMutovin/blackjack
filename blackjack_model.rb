require_relative 'blackjack_controller'

class BlackJackModel
  def calculate_score
    calculate_player_score
    calculate_dealer_score
  end

  def calculate_player_score
    self.player_score = 0
    player_cards.each do |card|
      if card.name.include?('A')
        add_ace_score(card)
      else
        self.player_score += card.score
      end
    end
    player_score_with_ace
  end

  def calculate_dealer_score
    self.dealer_score = 0
    dealer_cards.each do |card|
      if card.name.include?('A')
        add_ace_score(card)
      else
        self.dealer_score += card.score
      end
    end
    dealer_score_with_ace
  end

  def player_score_with_ace
    return if @ace_score.nil?

    @ace_score.each do |score|
      self.player_score += if player_score + score[1] <= 21
                             score[1]
                           else
                             score[0]
                           end
    end
    @ace_score = []
  end

  def dealer_score_with_ace
    return if @ace_score.nil?

    @ace_score.each do |score|
      self.dealer_score += if dealer_score + score[1] <= 21
                             score[1]
                           else
                             score[0]
                           end
    end
    @ace_score = []
  end

  def add_ace_score(card)
    @ace_score ||= []
    @ace_score << card.score
  end

  def continue?
    user_answer
    return true if answer == 'yes'

    raise 'Досвидания' if answer == 'no'
  end

  def draw_result
    return unless draw?

    return_start_bets
    raise 'Ничья'
  end

  def refresh_game
    refresh_players
    add_start_cards
    take_start_bets
    calculate_score
  end

  def draw?
    dealer_score == player_score
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
    raise "Превышено кол-во очков, Дилер проиграл(#{dealer_score},#{dealer_cards_names})" if dealer_score > 21

    21 - dealer_score < 21 - player_score
  rescue RuntimeError => e
    puts e.message
  end

  def max_cards?
    dealer_cards.length == 3 && player_cards.length == 3
  end

  def refresh_players
    @player_cards = []
    @dealer_cards = []
    @player_score = 0
    @dealer_score = 0
  end

  def add_start_cards
    deck.give_start_cards(@player_cards)
    deck.give_start_cards(@dealer_cards)
  end

  def take_start_bets
    player.add_bet
    dealer.add_bet
    raise 'У вас закончились деньги' if player.money.zero? || player.money.negative?
    raise 'У дилера закончились деньги' if dealer.money.zero? || dealer.money.negative?
  end

  def return_start_bets
    player.return_bet
    dealer.return_bet
  end

  def user_answer
    self.answer = gets.chomp
  end

  def player_cards_names
    player_cards.each(&:name)
  end

  def dealer_cards_names
    dealer_cards.each(&:name)
  end

  def make_choice(answer)
    send PLAYER_STEPS[answer]
  end
end
