module Judge

  class Power
    class LocationList
      include Enumerable

      def initialize(container)
        @container = container
        @list = nil
      end

      def initialize_copy(other)
        @list = @list.dup
      end
      
      def _read_list
        @list ||= [].to_set
      end
      alias :_write_list :_read_list

      def size
        @list.size
      end

      def each(&block)
        _read_list.each(&block)
      end

      def include?(center)
        center = @container.locations.fetch_province(center) unless center.kind_of? Location
        center && _read_list.include?(center)
      end
      
      def delete(center)
        center = @container.locations.fetch_province(center) unless center.kind_of? Location
        if center && _write_list.include?(center)
          _write_list.delete(center)
          center
        elsif block_given?
          yield
        end
      end

      def _replace(old_loc,new_loc)
        @list.add(new_loc) if @list && @list.delete(old_loc)
      end
      def _deleted_province(province)
        @list.delete(province) if @list
      end
    end
    
    class OwnsList < LocationList
      def _read_list
        @list || [].to_set
      end

      def add(center)
        center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Location
        if @container.supply_centers.owned?(center)
          raise AlreadyOwnedCenterError, "#{center} is already owned by #{@container.supply_centers.owner(center)}"
        end
        @container.supply_centers.add(center)
        _write_list.add(center)
      end
      
      def clear
        @list = [].to_set
        self
      end
      
      def finish(power)
        unless @list
          @list = power.homes.find_all {|c| !@container.supply_centers.owned?(c) }
        end
      end
    end
    class HomesList < LocationList
      def add(center)
        center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Location
        other_power = @container.powers.find{|p| p.homes.include?(center) }
        raise AlreadyHomeCenterError, "#{center} is already a home center for #{other_power}" if other_power
        @container.supply_centers.add(center)
        _write_list.add(center)
      end
      
      def clear
        _write_list.clear
        self
      end
    end
    class UnitList
      include Enumerable
      
      def initialize(container, power)
        @container = container
        @list = [].to_set
        @power = power
      end
      
      def each(&block)
        @list.each(&block)
      end
      
      def clear
        @list.clear
        self
      end
      
      def disband(unit)
        @list.delete(unit)
      end
      
      def move(unit,location)
        @list.delete(unit)
        unit = unit.moved(location)
        @list.add(unit)
        @container.powers.each{|p| p.units.dislodge(location)}
      end
      
      def clear_location(location)
        unit = @list.find{|u| u.location.province.eql?(location.province)}
        @list.delete(unit)
      end
      
      def dislodge(location)
        unit = @list.find{|u| u.location.province.eql?(location.province)}
        unit.dislodge if unit
      end
      
      def build(unit)
        @list.add(unit)
      end

      def build_fleet(location)
        location = @container.locations[location] unless location.is_a? Location
        @list.add(Fleet.new(@power, location))
      end

      def build_army(location)
        location = @container.locations[location] unless location.is_a? Location
        @list.add(Army.new(@power, location))
      end
    end
    
    attr_reader :homes, :owns, :units, :name
    attr_writer :own_word

    def initialize( container, name=nil)
      @container = container
      @name = name
      self.setup
    end
    
    def initialize_copy(other)
      @homes = @homes.dup
      @units = UnitList.new(@container, self)
      other.units.each{|u| @units.build(u.class.new(self, u.location)) }
      @owns = @owns.dup
    end
    
    def setup
      @own_word = nil
      @abbreviation = nil
      @homes = HomesList.new(@container)
      @units = UnitList.new(@container, self)
      @owns = OwnsList.new(@container)
    end
    
    def abbreviation
      @abbreviation || self.own_word[0...1].upcase
    end
    
    def abbreviation=(new_value)
      @abbreviation = new_value.upcase
    end
    
    def own_word
      @own_word || self.name
    end

    def validate
      raise InvalidPowerError, "No abbreviation provided" unless abbreviation
      raise InvalidPowerError, "No name provided" unless name
      raise InvalidPowerError, "No own word provided" unless own_word
    end
    
    def finish
      owns.finish(self)
    end

    def delete_center( center, &block )
      center = @container.locations.fetch_province(center) unless center.kind_of? Location
      if center && self.homes.delete(center)
        center
      elsif block_given?
        yield
      end 
    end
    
    def hash
      self.name.upcase.hash
    end
    
    def eql?(other)
      other.kind_of?(Power) && self.name.upcase.eql?(other.name.upcase)
    end
    
    def to_s
      "power #{self.name}"
    end

    def _deleted_province(province)
      homes._deleted_province(province)
      owns._deleted_province(province)
    end
    
    def _replace(old_loc,new_loc)
      owns._replace(old_loc,new_loc)
      homes._replace(old_loc,new_loc)
    end
  end
end
# vim: sts=4:sw=4:ts=4:et