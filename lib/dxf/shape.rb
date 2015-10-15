
module DXF

  class Shape
    attr_reader :name
    attr_accessor :layer
    
    def initialize(name)
      @name = name
      @layer = "0"
    end

    def to_array
      [0, @name, 8, @layer]
    end
  end

  class Line < Shape
    attr_reader :x1, :y1, :x2, :y2
    def initialize(x1, y1, x2, y2)
      super("LINE")
      @x1 = x1
      @y1 = y1
      @x2 = x2
      @y2 = y2
    end

    def to_array
      super +
        [10, @x1] + [20, @y1] + [11, @x2] + [21, @y2]
    end
  end

end
