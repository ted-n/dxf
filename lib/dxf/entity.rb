
module DXF
  
  DEMENSION = 2
  X = 0 # [X, Y]
  Y = 1 # Å™

  class Entity
    attr_reader :name
    attr_accessor :layer
    
    def initialize(type)
      @type = type
      @layer = "0"
      @subclass = ["AcDbEntity"]
      @handle = HandleManager.allocate
    end

    def to_array
      [0, @type, 8, @layer, 5, @handle.to_s(16)] +
      @subclass.collect { |subclass| [100, subclass] }.flatten
    end
  end

  class Line < Entity
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
  
  class LWPolyLine < Entity
    attr_reader :points
    
    def initialize(points, closed)
      super("LWPOLYLINE")
      @points = points
      @closed = closed
      @subclass = @subclass << "AcDbPolyline"
    end
    
    def to_array
      super +
      [90, points.count] + [70, @closed ? 1 : 0] +
      points.collect { |point| [10, point[X], 20, point[Y]] }.flatten
    end
  end
  
  class Text < Entity
    def initialize(point, height, message)
      super("TEXT")
      @point = point
      @height = height
      @message = message
      @subclass = @subclass << "AcDbText"
    end
    def to_array
      super +
      [10, @point[X], 20, @point[Y], 30, 0, 40, @height, 1, @message] +
      [100, @subclass[1]]
    end
  end
  
  class Block < Entity
    def initialize(name)
      super("BLOCK")
      @name = name
      @subclass << "AcDbBlockBegin"
    end
    def to_array
      super + [2, @name]
    end
  end
  
  class EndBlock < Entity
    def initialize
      super("ENDBLK")
      @subclass << "AcDbBlockEnd"
    end
  end
  
  # Utility Classes
  
  class Rectangle < LWPolyLine
    def initialize(point1, point2)
      point3 = [point1[X], point2[Y]]
      point4 = [point2[X], point1[Y]]
      super([point1, point3, point2, point4], true)
    end
  end

end
