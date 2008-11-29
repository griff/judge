module Judge
  class Power
    class LocationList
      include Enumerable

      def initialize(container)
        @container = container
        @list = [].to_set
      end

      def each(&block)
        @list.each(&block)
      end

      def include?(center)
        center = @container.locations.fetch_province(center) unless center.kind_of? Location
        center && @list.include?(center)
      end
      
      def delete(center)
        center = @container.locations.fetch_province(center) unless center.kind_of? Location
        center && @list.delete(center)
      end

      def _replace(old_loc,new_loc)
        @list.add(new_loc) if @list.delete(old_loc)
      end
      def _deleted_province(province)
        @list.delete(province)
      end
    end
    
    class OwnsList < LocationList
      def add(center)
        center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Location
        if !@list.include?(center) && @container.supply_centers.include?( center )
          @container.supply_centers.delete(center)
        end
        @list.add(center)
      end
      
      def clear
        @list.each{|c| delete(c)}
      end
      
      def delete(center)
        center = @container.locations.fetch_province(center) unless center.kind_of? Location
        if center && @list.delete(center)
          @container.unowned.add(center)
          center
        end
      end
    end
    class HomesList < LocationList
      def initialize(container, power)
        super(container)
        @power = power
      end
      
      def add(center)
        center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Location
        @power.owns.add(center)
        @list.add(center)
      end
      
      def clear
        @list.clear
      end
    end
    class UnitList
      include Enumerable
      
      def initialize(container)
        @container = container
        @list = [].to_set
      end
      
      def each(&block)
        @list.each(&block)
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
    end
    
    attr_reader :homes, :owns, :abbreviation, :units
    attr_accessor :name, :own_word

    def initialize( container, name=nil)
      @container = container
      @name = name
      self.setup
    end
    
    def setup
      @own_word = nil
      @abbreviation = nil
      @homes = HomesList.new(@container,self)
      @units = UnitList.new(@container)
      @owns = OwnsList.new(@container)
    end
    
    def abbreviation=(new_value)
      @abbreviation = new_value.upcase
    end

    def validate
      raise "No abbreviation provided" unless abbreviation
      raise "No name provided" unless name
      raise "No own word provided" unless own_word
    end

    def delete_center( center )
      center = @container.locations.fetch_province(center) unless center.kind_of? Location
      owns.delete(center) if center && homes.delete(center)
    end
    
    def hash
      self.name.hash
    end
    
    def eql?(other)
      other.kind_of?(Power) && self.name.eql?(other.name)
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