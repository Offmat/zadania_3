# Ship creator
class Ship
  attr_reader :location
  def initialize(n, location)
    @segments = n
    @location = location
  end

  def hit
    @segments -= 1
    return true if @segments < 1
    false
  end
end
