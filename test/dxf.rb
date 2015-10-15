require 'test/unit'
require 'dxf'
require 'dxf/shape'

class TestFile < Test::Unit::TestCase

  def test_file
    file = DXF::File.new
    file.entities.add(DXF::Line.new(100.0, 200.0, 300.0, 400.0))
    file.save("test.dxf")
  end

end
