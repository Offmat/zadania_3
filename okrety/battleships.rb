require 'pry'
require_relative 'board_presenter.rb'
require_relative 'board_creator.rb'

game_board = BoardCreator.create
board_presenter = BoardPresenter.new(game_board.board)

board_presenter.greetings
board_presenter.print_board
loop do
  target = board_presenter.take_shot
  game_board.ship_sunk(target) if board_presenter.react(game_board.shoot(target))
  board_presenter.print_board
  board_presenter.end_game if game_board.fleet < 1
end
