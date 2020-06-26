require_relative 'players'
require_relative 'player'
require_relative 'dealer'
require_relative 'card'
require_relative 'deck'
require_relative 'blackjack_view'
require_relative 'blackjack_model'

class BlackJackController < BlackJackModel
  attr_accessor :answer, :player, :dealer, :deck, :player_cards, :dealer_cards,
                :player_score, :dealer_score

  PLAYER_STEPS = { '1' => :player_miss, '2' => :add_player_card, '3' => :open_cards }.freeze

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
    @player_cards = []
    @dealer_cards = []
    @player_score = 0
    @dealer_score = 0
  end

  def start_game
    player.name = user_answer
    add_start_cards
    take_start_bets
    calculate_score
  end

  def choose_step
    user_answer
  end

  def player_miss
    return if dealer_score > 17 || dealer_cards.length == 3

    add_dealer_card
  end

  def add_dealer_card
    dealer_cards << deck.add_card

    calculate_score
  rescue RuntimeError => e
    puts e.message
  end

  def add_player_card
    player_cards << deck.add_card
    calculate_score
    raise "Превышено кол-во очков, Вы проиграли(#{player_score}, #{player_cards_names})" if player_score > 21

    player_miss
  end

  def open_cards
    draw_result
    dealer_win? ? dealer_win_result : player_win_result
  rescue RuntimeError => e
    puts e.message
  end
end
