module Judge
  class MapReader
    class PlaceEdge
      attr_reader :location, :restrictions

      def initialize(location, restrictions)
        @location = location
        @restrictions = restrictions
      end
    end

    class CoastEdge
      attr_reader :name, :restrictions
      def initialize(name, restrictions)
        @name = name
        @restrictions = restrictions
      end
    end

    class ProvinceEdge < PlaceEdge
      def /(coast)
        raise "Not a coast" unless coast.is_a? CoastEdge
        raise "Province has restrictions" if @restrictions.size > 0
        PlaceEdge.new(@location.fetch_or_create_coast(coast.name), coast.restrictions)
      end
    end
  
    class LocationReader
      def initialize(map, loc)
        @map = map
        @loc = loc
      end
    
      def name(new_value)
        @loc.name = new_value
      end
    
      def aliases(*args)
        args.flatten.each {|a| @loc.aliases.add(a) }
      end
    
      def ambiguous(*args)
        args.flatten.each {|a| @loc.ambiguous.add(a) }
      end
    
      def adjacencies(*args)
        args.each do |to|
          raise "Coast without a province" if to.is_a? CoastEdge
          raise "Not a map location #{to}" unless to.is_a? PlaceEdge
          
          edge = Judge::MovementEdge.new(@loc, to.location)
          edge.disallowed_units to.restrictions
          @loc.adjacencies.add(edge)
        end
      end
    
      def _validate
        @loc.validate
      end
    
      def method_missing(sym, *args)
        coasts = %w{sc ec nc wc}
        return super if sym.to_s.size != 3 && !coasts.include?(sym.to_s.downcase)
        #args.each{|r| raise "Invalid restriction #{r}" unless r.include? Unit } 
        
        if coasts.include?(sym.to_s.downcase)
          CoastEdge.new(sym.to_s, args)
        else
          ProvinceEdge.new(@map.locations.fetch_or_create_province(sym.to_s), args)
        end
      end
    end
    class CoastReader < LocationReader
      def initialize(map, parent,loc)
        super(map, loc)
        @parent = parent
      end
      def _validate
        @loc.terrain = @parent.terrain
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
      def initialize(map, loc)
        super(map, loc)
        @coasts = []
      end
    
      def terrain(terrain)
        terrain = terrain.instance if terrain.is_a? Class
        @loc.terrain = terrain
      end
    
      def coast(abbr)
        province = @map.locations.fetch_or_create_place(@loc.abbreviation, abbr)
        reader = CoastReader.new(map, @loc, province)
        yield reader
        @coasts << reader
      end
    
      def _validate
        super
        @coasts.each do |c|
          c._validate
        end
      end
    end
  
    class PowerReader
      def initialize(power)
        @power = power
      end

      def owns(*locations)
        locations.flatten.each{|l| @power.owns.add(l) }
      end

      def homes(*locations)
        locations.flatten.each{|l| @power.homes.add(l) }
      end
    end
  
    def self.const_missing(const)
      if Judge::Location.const_defined?(const)
        Judge::Location.const_get(const)
      else
        super
      end
    end
    
    def self.read(file)
      data = IO.read(file)
      map = Map.new
      map.name = File.basename(file, '.rb')
      reader = MapReader.new(map)
      reader.instance_eval data, file, 1
      map.finish
      map.validate
      map
    end
    
    def initialize(map)
      @map = map
    end
    
    def requires(extension)
      Judge.load_extension(extension)
    end
    
    def visual(value)
      @map.visual = value
    end
    
    def power(power_name, own_word=nil, abbreviation=nil, &block)
      power = @map.fetch_or_create_power(power_name, own_word)
      reader = PowerReader.new(power)
      if block_given?
        reader.instance_eval(&block)
      else
        reader
      end
    end
    
    def unowned(*locations)
      locations.flatten.each{|l| @map.unowned.add(l)}
    end
    
    def province(abbr, &block)
      province = @map.locations.fetch_or_create_province(abbr)
      reader = ProvinceReader.new(@map, province)
      reader.instance_eval(&block)
      reader._validate
    end
  end
end