require 'test/unit'
require 'dxf'
require 'dxf/entity'
include DXF
include Math

class TestFile < Test::Unit::TestCase
  
  class << self
    def startup
      #p "startup"
      @@file = DXF::File.new
    end
    def shutdown
      #p "shutdown"
      @@file.save("test.dxf")
    end
  end
  
=begin
  
  #def test_simple_line
  #  @file.entities.add(DXF::Line.new([100.0, 200.0], [300.0, 400.0]))
  #end
  
  def test_polygon_line
    side = 6
    length = 3
    point = [0.5, 0.5]
    next_point = []
    
    angle = Math::PI / 2
    delta = (2 * Math::PI) / side

    side.times do
      next_point[X] = point[X] + length * Math.cos(angle)
      next_point[Y] = point[Y] + length * Math.sin(angle)
      angle = angle + delta
      @@file.entities.add(Line.new(point, next_point))
      point = next_point.dup
    end
  end
=end

  def test_rectangle
    @@file.entities.add(DXF::Rectangle.new([0.5, 0.5], [2, 2]))
  end
    
end
