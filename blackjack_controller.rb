require_relative 'players'
require_relative 'player'
require_relative 'dealer'
require_relative 'card'
require_relative 'deck'
require_relative 'blackjack_view'

class BlackJackController
  attr_accessor :player, :dealer, :deck

  PLAYER_STEPS = { '1' => :player_miss, '2' => :player_take_card, '3' => :open_cards }.freeze

  def initialize(answer)
    @player = Player.new(answer)
    @dealer = Dealer.new('Дилер')
    @deck = Deck.new
  end

  def start_game
    add_start_cards(deck)
    take_start_bets
  end

  def player_miss
    return if dealer.score > 17 || dealer.cards.length == 3

    give_card(dealer)
  end

  def open_cards
    draw_result
    dealer_win? ? dealer_win_result : player_win_result
  rescue RuntimeError => e
    puts e.message
  end

  def give_card(player)
    player.take_card(deck)
    if player.score > 21
      raise "Превышено кол-во очков, Игрок: #{player.name} проиграл(#{player.score}, #{player.cards})"
    end

    player_miss
  end

  def max_cards?
    dealer.cards.length == 3 && player.cards.length == 3
  end

  def continue?(answer)
    return true if answer == 'yes'

    raise 'Игра окончена' if answer == 'no'
  end

  def draw_result
    return unless draw?

    return_start_bets
    raise 'Ничья'
  end

  def refresh_game
    refresh_players
    add_start_cards(deck)
    take_start_bets
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
    raise "Превышено кол-во очков, Дилер проиграл(#{dealer.score},#{dealer.cards})" if dealer.score > 21

    21 - dealer.score < 21 - player.score
  rescue RuntimeError => e
    puts e.message
  end

  def refresh_players
    @player.cards = []
    @dealer.cards = []
    @player.score = 0
    @dealer.score = 0
    @deck = Deck.new
  end

  def add_start_cards(deck)
    player.take_start_cards(deck)
    dealer.take_start_cards(deck)
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

  def make_choice(answer, *player)
    send PLAYER_STEPS[answer], player if answer == '2'
    send PLAYER_STEPS[answer]
  end
end
