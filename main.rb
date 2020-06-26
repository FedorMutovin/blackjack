require_relative 'blackjack_controller'

blackjack = BlackJackController.new
game = BlackJackView.new(blackjack)
game.start