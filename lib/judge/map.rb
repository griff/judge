module Judge
  class Map
    attr_reader :locations, :unowned
    attr_accessor :visual
    
    def initialize
      @locations = Locations.new
      @powers = []
      @powers_wrap = ImmutableWrapper.new(@powers)
      @unowned = []
    end
    
    def each_suplycenter(&block)
      @unowned.each(&block)
      @powers.each do |power|
        power.homes.each(&block)
      end
    end

    def add_unowned( center )
      center = locations.fetch_or_create_province(center) unless center.kind_of? Location
      @unowned << center unless supply_center?(center)
    end

    def delete_unowned( center )
      center = locations.fetch_province(center) unless center.kind_of? Location
      @unowned.delete(center) if center
    end

    def supply_center?( center )
      center = locations.fetch_province(center) unless center.kind_of? Location
      unowned.any?{|c|  c == center } or
      owned_supply_center?(center)
    end
    
    def owned_supply_center?(center)
      center = locations.fetch_province(center) unless center.kind_of? Location
      @powers.any? do |power|
        power.homes.any? { |c| c == center } 
      end
    end

    def fetch_power(power_name)
      power_name = power_name.upcase
      @powers.find{ |p| p.name.upcase == power_name}
    end

    def fetch_or_create_power(power_name)
      power_name_u = power_name.upcase
      power = @powers.find{ |p| p.name.upcase == power_name}
      unless power
        @powers.push( power = Power.new(self, power_name) )
      end
      power
    end

    def powers
      @powers_wrap
    end

    def deleted_province(province)
      @powers.each{|p| p.deleted_province(province)}
    end
    
    def validate
      @powers.all?{|p| p.validate} && @unowned.all?{|p| p.validate}
      locations.validate
    end
  end
end
# vim: sts=4:sw=4:ts=4:et