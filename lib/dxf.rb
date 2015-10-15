require "dxf/version"

module DXF

  class Group
    attr_reader :code, :value
    
    def initialize(code, value)
      @code = code
      @value = value
    end

    def to_array
      [@code, @value]
    end
    
    def write(io)
      io.write(to_array).join("\n")
      io.write("\n")
    end
  end

  class Groups
    attr_reader :list

    def initialize(list = [])
      @list = list
    end

    def to_array
      result = []
      list.each do |group|
        result << group.to_array
      end
      result
    end

    def << (shape)
      @list << shape
    end
  end

  class Section
    attr_reader :name, :content

    def initialize(name)
      @name = name
      @content = Groups.new
    end

    def to_array
      [0, "SECTION"] + [2, @name] + @content.to_array + [0, "ENDSEC"]
    end

    def write(io)
      io.write(to_array.join("\n"))
      io.write("\n")
    end
  end
  
  class Header < Section
    def initialize
      super("HEADER")
    end
  end

  class Entities < Section
    def initialize
      super("ENTITIES")
    end

    def add(shape)
      @content << shape
    end
  end
  
  class File
    attr_reader :entities

    def initialize
      @header = Header.new
      @entities = Entities.new
    end

    def to_array
      @header.to_array + @entities.to_array + [0, "EOF"]
    end

    def save(filename)
      ::File.open(filename, "wt") do |file|
        @header.write(file)
        @entities.write(file)
        file.write("0\nEOF\n")
      end
    end
    
  end
end
