require_relative 'game_board.rb'
require_relative 'ship.rb'
# aaa
# class that creates game_board and puts ships inside of it.
class BoardCreator
  def create
    game_board = GameBoard.new.tap(&:generate_board)
    fleet_generator(game_board)
    game_board
  end

  def ship_generator(n, game_board)
    seg = 1
    ship = [] << game_board.avalible.sample
    direction = rand(2)
    while seg < n
      ship[seg] = ship[seg - 1].dup
      ship[seg][direction] += 1
      return false if !game_board.avalible.include?([ship[seg][0], ship[seg][1]])
      seg += 1
    end
    unit = Ship.new(n, ship)
    ship.each { |segm| game_board.insert_ship(segm[0], segm[1], unit) }
    true
  end

  def fleet_generator(game_board)
    until ship_generator(4, game_board); end
    2.times { until ship_generator(3, game_board); end }
    3.times { until ship_generator(2, game_board); end }
    4.times { until ship_generator(1, game_board); end }
  end
end
