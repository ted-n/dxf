require "dxf/version"
require "dxf/table"

module DXF
  
  class HandleManager
    class << self
      @@handle = 1000
      def allocate
        @@handle += 1
      end
    end
  end

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
    
    def << (group)
      @list << group
    end

    def to_array
      result = []
      list.each do |group|
        result.concat(group.to_array)
      end
      result
    end
  end

  class Section
    attr_reader :name, :content

    def initialize(name)
      @name = name
      @content = Groups.new
    end
    
    def add(object)
      @content << object
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
    
    class Variable < Group
      def initialize(name, code, value)
        super(9, name)
        @var_code = code
        @var_value = value
      end
      def to_array
        super + [@var_code, @var_value]
      end
    end

    def initialize
      super("HEADER")
      add(Variable.new("$ACADVER", 1, "AC1024"))
      add(Variable.new("$HANDSEED", 5, "400"))
    end
  end
  
  class Tables < Section
    def initialize
      super("TABLES")
      add(LayerTable.new("0"))
      add(AppIDTable.new("RubyDXF"))
    end
  end
  
  class Entities < Section
    def initialize
      super("ENTITIES")
    end
  end
  
  class File
    attr_reader :entities

    def initialize
      @header = Header.new
      @tables = Tables.new
      @entities = Entities.new
    end

    def to_array
      @header.to_array + @tables.to_array + @entities.to_array + [0, "EOF"]
    end

    def save(filename)
      ::File.open(filename, "wt") do |file|
        to_array.each do |line|
          file.write(line)
          file.write("\n")
        end
        file.write("0\nEOF\n")
      end
    end
    
  end
end
