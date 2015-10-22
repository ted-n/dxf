
module DXF
  
  DEMENSION = 2
  X = 0 # [X, Y]
  Y = 1 # Å™

  class Shape
    attr_reader :name
    attr_accessor :layer
    
    def initialize(name)
      @name = name
      @layer = "0"
      @subclass = ["AcDbEntity"]
      @handle = HandleManager.allocate
    end

    def to_array
      [0, @name, 8, @layer, 5, @handle.to_s(16)] +
      @subclass.collect { |subclass| [100, subclass] }.flatten
    end
  end

  class Line < Shape
    attr_reader :p1, :p2
    
    def initialize(p1, p2)
      super("LINE")
      @p1 = p1.dup
      @p2 = p2.dup
    end

    def to_array
      super +
        [10, @p1[X]] + [20, @p1[Y]] + [11, @p2[X]] + [21, @p2[Y]]
    end
  end
  
  class LWPolyLine < Shape
    attr_reader :points
    
    def initialize(points)
      super("LWPOLYLINE")
      @points = points
      @subclass = @subclass << "AcDbPolyline"
    end
    
    def to_array
      super +
      [90, points.count] +
      points.collect { |point| [10, point[X], 20, point[Y]] }.flatten
    end
  end
  
  class Rectangle < LWPolyLine
    def initialize(point1, point2)
      super([point1, point2])
    end
  end

end
