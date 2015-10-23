require "dxf"

module DXF
  
  class TableRecord
    def initialize(name)
      @name = name
      @content = Groups.new
      @handle = HandleManager.allocate
    end
    def addGroup(code, value)
      @content.addGroup(code, value)
    end
    def to_array
      [0, @name] + [5, @handle.to_s(16)] + [100, "AcDbSymbolTableRecord"] +
      @content.to_array
    end
  end
  
  class Table
    attr_reader :name, :content
    
    def initialize(name, handle)
      @name = name
      @content = Groups.new
      @handle = handle
      addGroup(100, "AcDbSymbolTable")
    end
    
    def addGroup(code, value)
      @content.addGroup(code, value)
    end
    
    def to_array
      [0, "TABLE"] + [2, @name] + [5, @handle.to_s(16)] +
      @content.to_array + [0, "ENDTAB"]
    end
  end
  
  class LTypeTable < Table
    
    class LinetypeTableRecord < TableRecord
      def initialize(name, description)
        super("LTYPE")
        addGroup(100, "AcDbLinetypeTableRecord")
        addGroup(2, name)
        addGroup(70, 0)
        addGroup(3, description)
        addGroup(72, 65)
        addGroup(73, 0)
        addGroup(40, 0.0)
      end
    end
    
    def initialize
      super("LTYPE", 5)
      @content << LinetypeTableRecord.new("ByBlock", "")
      @content << LinetypeTableRecord.new("ByLayer", "")
    end
  end

  class LayerTable < Table
  
    class LayerTableRecord < TableRecord
      def initialize(name)
        super("LAYER")
        addGroup(100, "AcDbLayerTableRecord")
        addGroup(2, name)
        addGroup(70, 0)    # flag
        addGroup(390, "F") # PlotStyleName handle
      end
    end
    
    def initialize(name)
      super("LAYER", 2)
      @content << LayerTableRecord.new(name)
    end
  end
  
  class TextStyleTable < Table
    def initialize
      super("STYLE", 0x11)
    end
  end
  
  class ViewTable < Table
    def initialize
      super("VIEW", 6)
      addGroup(70, 0) # flag
    end
  end
  
  class UCSTable < Table
    def initialize
      super("UCS", 7)
      addGroup(70, 0) # flag
    end
  end
  
  class AppIDTable < Table
    
    class AppIDTableRecord < TableRecord
      def initialize(id)
        super("APPID")
        addGroup(100, "AcDbRegAppTableRecord")
        addGroup(2, id)
        addGroup(70, 0)
      end
    end

    def initialize(name)
      super("APPID", 9)
      @content << AppIDTableRecord.new(name)
    end
  end
  
  class BlockRecordTable < Table
    class BlockTableRecord < TableRecord
      def initialize(name)
        super("BLOCK_RECORD")
        addGroup(100, "AcDbBlockTableRecord")
        addGroup(2, name)
      end
    end
    
    def initialize
      super("BLOCK_RECORD", 1)
    end
    
    def add(name)
      @content << BlockTableRecord.new(name)
    end
  end
  
  class VPortTable < Table
    def initialize
      super("VPORT", 8)
    end
  end
  
  class DimStyleTable < Table
    def initialize
      super("DIMSTYLE", 0xA)
      addGroup(100, "AcDbDimStyleTable")
    end
  end
  
end
