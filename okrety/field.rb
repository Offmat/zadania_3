# board field
class Field
  attr_reader :visible, :ship, :unit
  def initialize
    @visible = false
    @ship = false
  end

  def place_ship(unit)
    @ship = true
    @unit = unit
  end

  def shoot
    return 3 if @visible == true
    @visible = true
    return 0 if @ship == false
    return 2 if @unit.hit
    1
  end

  def make_visible
    @visible = true
  end
end
