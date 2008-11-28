module Judge
  class LocationReader
    def initialize(loc)
      @loc = loc
    end
    
    def name=(new_value)
      @loc.name = new_value
    end
    
    def aliases(*args)
      args.each {|a| @loc.aliases.add(a) }
    end
    
    def ambiguous(*args)
      args.each {|a| @loc.ambiguous.add(a) }
    end
    
    def coast(abbr)
      province = @map.locations.fetch_or_create_place(@loc.abbreviation, abbr)
      reader = CoastReader.new(@loc, province)
      yield reader
      @coasts << reader
    end
    
    def validate
      @loc.validate
    end
  end
  class CoastReader < LocationReader
    def initialize(parent,loc)
      super(loc)
    end
    def validate
      @loc.type = @parent.type
      unless @loc.name
        name = case @loc.coast
          when 'sc'
            'south coast'
          when 'ec'
            'east coast'
          when 'nc'
            'north coast'
          when 'wc'
            'west coast'
        end
        @loc.name = @parent.name + ' ('+name+')' if name
      end
      super
    end
  end
  class ProvinceReader < LocationReader
    def initialize(loc)
      super(loc)
      @coasts = []
    end
    
    def type=(type_value)
       @loc.type = type_value
    end
    
    def validate
      super
      @coasts.each do |c|
        c.validate
      end
    end
  end
  
  class MapReader
    def self.define_map(name,&block)
      MapReader.new(name,&block)
    end
    
    def initialize(name)
      @map = Map.new
      @map.name = name
      yield self
      finish
      validate
    end
    
    def requires(extension)
      Judge.load_extension(extension)
    end
    
    def visual=(value)
      @map.visual = value
    end
    
    def visual
      @map.visual
    end
    
    def province(abbr)
      province = @map.locations.fetch_or_create_province(abbr)
      reader = ProvinceReader.new(province)
      yield reader
      reader.validate
    end
    
    def finish
      @map.visual = @map.name unless @map.visual
    end
    
    def validate
    end
  end
end