require "dxf"

module DXF
  
  class TableRecord
    def initialize(name)
      @name = name
      @content = Groups.new
      @handle = HandleManager.allocate
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
      add(Group.new(100, "AcDbSymbolTable"))
    end
    
    def add(object)
      @content << object
    end
    
    def to_array
      [0, "TABLE"] + [2, @name] + [5, @handle.to_s(16)] +
      @content.to_array + [0, "ENDTAB"]
    end
  end
    
  class LayerTable < Table
  
    class LayerTableRecord < TableRecord
      def initialize(name)
        super("LAYER")
        @content << Group.new(100, "AcDbLayerTableRecord")
        @content << Group.new(2, name)
        @content << Group.new(70, 0)    # flag
        @content << Group.new(390, "F") # PlotStyleName handle
      end
    end
    
    def initialize(name)
      super("LAYER", 2)
      add(LayerTableRecord.new(name))
    end
  end
  
  class ViewTable
  end
  
  class UCSTable
  end
  
  class AppIDTable < Table
    
    class AppIDTableRecord < TableRecord
      def initialize(id)
        super("APPID")
        @content << Group.new(100, "AcDbRegAppTableRecord")
        @content << Group.new(2, id)
        @content << Group.new(70, 0)
      end
    end

    def initialize(name)
      super("APPID", 9)
      add(AppIDTableRecord.new(name))
    end
  end
  
  class BlockRecordTable
  end
  
  class VPortTable
  end
  
  class DimStyleTable
  end
  
end
