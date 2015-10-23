
module DXF
  
  # notice this DXF::Object <> ::Object
  class Object
    def initialize(type, handle = nil)
      @type = type
      @handle = (handle.nil?) ? HandleManager.allocate : handle
    end
    def to_array
      [0, @type, 5, @handle.to_s(16)]
    end
  end
  
  class Dictionary < Object
    attr_reader :items
    
    def initialize(handle = nil)
      super("DICTIONARY", handle)
      @subclass = "AcDbDictionary"
      @items = {}
    end
    def to_array
      list = []
      @items.each {|key, value| list = list + [3, key, 350, value] }
      super + [100, @subclass] + list
    end
  end
  
end
