module Judge
  class Map
    class UnownedList
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
      end

      def add(center)
        center = @map.locations.fetch_or_create_province(center) unless center.kind_of? Location
        @list.add(center) unless @map.supply_centers.include?(center)
      end

      def delete(center)
        center = @map.locations.fetch_province(center) unless center.kind_of? Location
        @list.delete(center) if center
      end

      def _replace(old_loc, new_loc)
        if @list.delete(old_loc)
          @list.add(new_loc)
        end
      end
    end
    
    class SupplyCenterList
      include Enumerable

      def initialize(map)
        @map = map
      end
      
      def each(&block)
        @map.unowned.each(&block)
        @map.powers.each do |power|
          power.owns.each(&block)
        end
      end
      
      def include?(center)
        center = @map.locations.fetch_province(center) unless center.kind_of? Location
        @map.unowned.include?(center) or
        @map.powers.any? do |power|
          power.owns.include?(center)
        end
      end
      
      def delete(center)
        center = @map.locations.fetch_province(center) unless center.kind_of? Location
        if center 
          @map.powers.each{|p| p.owns.delete(center)} 
          @map.unowned.delete(center)
        end
      end
    end

    attr_reader :locations, :unowned, :supply_centers
    attr_accessor :visual, :name
    
    def initialize
      @locations = Locations.new(self)
      @powers = [].to_set
      @powers_wrap = ImmutableWrapper.new(@powers)
      @unowned = UnownedList.new(self)
      @supply_centers = SupplyCenterList.new(self)
    end

    def fetch_power(power_name)
      power_name = power_name.upcase
      @powers.find{ |p| p.name.upcase == power_name}
    end

    def fetch_or_create_power(power_name, own_word, abbreviation)
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
    
    def validate
      @powers.each{|p| p.validate} && @unowned.each{|p| p.validate}
      locations.validate
    end
    
    def _replace(old_loc,new_loc)
      powers.each do |p|
        p._replace(old_loc,new_loc)
      end
      unowned._replace(old_loc,new_loc)
    end

    def _deleted_province(province)
      @powers.each{|p| p._deleted_province(province)}
    end
  end
end
# vim: sts=4:sw=4:ts=4:et