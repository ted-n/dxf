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
    
    def addGroup(code, value)
      self.<<(Group.new(code, value))
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
      
      add(VPortTable.new)
      add(LTypeTable.new)
      add(LayerTable.new("0"))
      add(TextStyleTable.new)
      add(ViewTable.new)
      add(UCSTable.new)
      add(AppIDTable.new("ACAD"))
      add(DimStyleTable.new)
      @block_records = BlockRecordTable.new
      add(@block_records)
    end
    def registerBlock(block)
      @block_records.add(block.name)
    end
  end
  
  class Blocks < Section
    def initialize
      super("BLOCKS")
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
      @blocks = Blocks.new
      @entities = Entities.new
      @sections = [@header, @tables, @blocks, @entities]
      addBlock("*Model_Space")
      addBlock("*Paper_Space")
    end

    def to_array
      @sections.collect {|section| section.to_array}.flatten +
      [0, "EOF"]
    end
    
    def addBlock(name)
      block = Block.new(name)
      end_block = EndBlock.new
      @blocks.add(block)
      @blocks.add(end_block)
      @tables.registerBlock(block)
    end

    def save(filename)
      ::File.open(filename, "wt") do |file|
        to_array.each do |line|
          file.write(line)
          file.write("\n")
        end
      end
    end
    
  end
end
