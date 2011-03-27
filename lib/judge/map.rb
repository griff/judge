module Judge
  class Map
    class SupplyCenterList
      include Enumerable

      def initialize(map)
        @map = map
        @list = [].to_set
      end

      def each(&block)
        @list.each(&block)
      end

      def clear
        @list.clear
        self
      end
      
      def -(other)
        @list - other
      end

      def add(center)
        center = @map.locations.fetch_or_create_province(center) unless center.kind_of? Location
        check_before_add(center)
        @list.add(center)
      end
      
      def delete(center, &block)
        center = @map.locations.fetch_province(center) unless center.kind_of? Location
        if center
          @map.powers.each{|p| p.owns.delete(center); p.homes.delete(center) }
          @list.delete(center, &block)
        elsif block_given?
          yield
        end
      end
      
      def owned?(center)
        center = @map.locations.fetch_province(center) unless center.kind_of? Location
        center && @map.powers.any?{|p| p.owns.include?(center) }
      end

      def owner(center)
        center = @map.locations.fetch_province(center) unless center.kind_of? Location
        @map.powers.find{|p| p.owns.include?(center) } if center
      end
      
      def _replace(old_loc, new_loc)
        if @list.include?(old_loc)
          @list.delete(old_loc)
          @list.add(new_loc)
        end 
      end
      
      protected
        def check_before_add(center)
        end
    end
    
    class UnownedList
      include Enumerable

      def initialize(map)
        @map = map
      end
      
      def _list
        @map.supply_centers - @map.powers.map{|p| p.owns.to_a }.flatten
      end
      
      def each(&block)
        _list.each(&block)
      end

      def add(center)
        @map.supply_centers.add(center)
      end
      
      def include?(center)
        center = @map.locations.fetch_province(center) unless center.kind_of? Location
        _list.include?(center)
      end
      
      def delete(center, &block)
        center = @map.locations.fetch_province(center) unless center.kind_of? Location
        if center && !@map.powers.any?{|p| p.owns.include?(center) }
          @map.supply_centers.delete(center, &block)
        elsif block_given?
          yield
        end
      end
    end

    attr_reader :locations, :unowned, :supply_centers
    attr_accessor :name
    attr_writer :visual, :victory
    
    def initialize
      @locations = Locations.new(self)
      @powers = [].to_set
      @powers_wrap = ImmutableWrapper.new(@powers)
      @unowned = UnownedList.new(self)
      @supply_centers = SupplyCenterList.new(self)
      @visual = nil
      @victory = nil
    end
    
    def visual
      @visual || self.name
    end
    
    def victory
      @victory || (locations.size / 2)+1
    end

    def fetch_power(power_name)
      power_name = power_name.upcase
      @powers.find{ |p| p.name.upcase == power_name}
    end

    def fetch_or_create_power(power_name, own_word=nil, abbreviation=nil)
      own_word = power_name unless own_word
      abbreviation = own_word[0...1] unless abbreviation

      power_name_u = power_name.upcase
      own_word_u = own_word.upcase
      abbreviation_u = abbreviation.upcase
      power = @powers.find do |p| 
        (p.name && p.name.upcase == power_name_u) || 
        (p.own_word && p.own_word.upcase == own_word_u) ||
        (p.abbreviation && p.abbreviation.upcase == abbreviation_u)
      end
      unless power
        @powers.add( power = Power.new(self, power_name) )
        power.own_word = own_word
        power.abbreviation = abbreviation
      end
      power
    end

    def powers
      @powers_wrap
    end

    def finish
      @powers.each{|p| p.finish}
      locations.finish
    end
    
    def validate
      raise MissingPowerError, "A map requires at least 2 powers, #{@powers.size} was provided" if @powers.size < 2
      raise MissingLocationsError, "A map requires at least 1 location, non were provided" if locations.size == 0
      @powers.each{|p| p.validate}
      locations.validate
    end
    
    def _replace(old_loc,new_loc)
      powers.each do |p|
        p._replace(old_loc,new_loc)
      end
      supply_centers._replace(old_loc,new_loc)
    end

    def _deleted_province(province)
      @powers.each{|p| p._deleted_province(province)}
    end
  end
end
# vim: sts=4:sw=4:ts=4:et